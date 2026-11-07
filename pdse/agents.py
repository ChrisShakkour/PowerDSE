"""The multi-agent DSE of the thesis proposal (Section 3.1), as a LangGraph graph over the offline oracle.

    init ─► router[LLM] ─► evaluate[py] ─► budget left? ─no─► END
                               ▲                │yes
                               │                ▼
                         arbitrator[LLM] ◄─ specialists[LLM: performance (+ power)]

LLM nodes have no tools: they read a compact text state and answer one JSON object, validated in Python; a reply
that is not valid JSON, names an unknown knob value or repeats an evaluated design gets one corrective retry, then
falls back to a random unevaluated design (counted in `fallbacks`). Python owns the budget, the history and the
Pareto archive.

Agents (proposal Section 6.3, plus ablation D):
    A  latency only: sees cycles/latency and area, minimizes latency under an area cap
    B  power-aware:  also sees power, minimizes power with latency <= (1 + slack) × A's best latency
    C  Pareto:       sees all three, maximizes the (latency, area, power) hypervolume
    D  C plus a table of knob -> expected power direction in the system prompt (knowledge-gap ablation)
"""

from __future__ import annotations

import json
import random
import re
import time
from dataclasses import dataclass, field
from typing import Any, TypedDict

from langgraph.graph import END, StateGraph

from . import pareto
from .oracle import OBJECTIVES, BudgetExhausted, Oracle, random_point
from .space import KNOBS, Point

KNOB_DOC = """\
- mhz: clock target for HLS scheduling, one of [250, 500, 750, 1000]. Higher targets add pipeline registers and
  cycles; a design is credited at min(target, achieved Fmax), so overshooting only costs area and power.
- unroll: inner-loop unroll factor, one of [1, 2, 4, 8]. More parallel multiply-adds per cycle, more area.
- mem: memory interface, one of ["11", "nn2", "nn4"]: 1, 2 or 4 parallel memory ports (more concurrent loads).
- popt: Bambu --power-optimization, 0 or 1.
- frac: multiplier fracturing, 0 (off) or 16 (multiplies split into <=16-bit pieces)."""

POWER_HINTS = """\
Known tendencies on this flow (ASAP7, logic synthesis, activity from simulation):
- Dynamic power ~ switching activity x capacitance x frequency: a lower effective clock lowers power but raises latency.
- Unrolling raises parallel switching (power) and area, and lowers cycles; energy per call can still fall.
- More memory ports add interface logic and multiplexers (power, area) but cut cycles when loads are the bottleneck.
- popt=1 may gate registers and reduce sequential power at little latency cost.
- frac=16 adds adder trees around smaller multipliers: usually more area/power, sometimes a higher Fmax."""

SYSTEM = """You are an expert in high-level synthesis (HLS) design space exploration, working with the Bambu HLS tool
on an ASAP7 7nm ASIC flow. The kernel is a 64x64 int32 matrix multiply (triple loop, 262,144 multiply-accumulates):

    for i: for j: {{ sum = 0; for k: sum += m1[i*64+k] * m2[k*64+j]; prod[i*64+j] = sum; }}

A design point sets five knobs:
{knobs}
{hints}
Reply with ONE JSON object and nothing else."""

GOALS = {
    "A": "Minimize latency (us) while keeping cell area <= {area_cap:.0f} um^2. Power is not reported to you.",
    "B": "Minimize power (W) while keeping latency <= {lat_cap:.2f} us and cell area <= {area_cap:.0f} um^2.",
    "C": "Find designs on the Pareto front of (latency, area, power), all to be minimized: maximize the hypervolume "
         "of the evaluated set. Diverse trade-offs are valuable, not just one extreme.",
}
GOALS["D"] = GOALS["C"]


@dataclass
class Task:
    kind: str  # A | B | C | D
    budget: int = 20
    area_cap: float = float("inf")
    lat_cap: float = float("inf")
    top_k: int = 8

    @property
    def sees_power(self) -> bool:
        return self.kind != "A"

    def goal(self) -> str:
        return GOALS[self.kind].format(area_cap=self.area_cap, lat_cap=self.lat_cap)


class S(TypedDict, total=False):
    proposals: dict[str, Any]
    next: dict[str, Any]
    log: list[dict]


@dataclass
class Run:
    """One agent run: holds the oracle, the LLM and the bookkeeping the graph nodes share."""
    task: Task
    oracle: Oracle
    llm: Any
    seed: int = 0
    rng: random.Random = field(init=False)
    history: list[dict] = field(default_factory=list)
    calls: int = 0
    tokens_in: int = 0
    tokens_out: int = 0
    fallbacks: int = 0
    retries: int = 0
    transcript: list[dict] = field(default_factory=list)

    def __post_init__(self):
        self.rng = random.Random(self.seed)

    # ---------- text views of the state ----------
    def _fmt(self, h: dict) -> str:
        c = Point.from_id(h["id"])
        cfg = f"mhz={c.mhz} unroll={c.unroll} mem={c.mem} popt={c.popt} frac={c.frac}"
        if not h["valid"]:
            return f"{cfg} -> INVALID (HLS or co-simulation failed)"
        parts = [f"latency={h['latency_us']:.1f}us", f"cycles={h['cycles']:.0f}", f"f_eff={h['f_eff_mhz']:.0f}MHz",
                 f"area={h['area_um2']:.0f}um^2"]
        if self.task.sees_power:
            parts.append(f"power={h['power_w'] * 1e3:.2f}mW")
        return f"{cfg} -> " + " ".join(parts)

    def _objective_key(self, h: dict) -> float:
        if not h["valid"]:
            return float("inf")
        t = self.task
        if t.kind == "A":
            return h["latency_us"] + (1e9 if h["area_um2"] > t.area_cap else 0)
        if t.kind == "B":
            bad = h["latency_us"] > t.lat_cap or h["area_um2"] > t.area_cap
            return h["power_w"] + (1e9 if bad else 0)
        return 0.0

    def front_ids(self) -> list[str]:
        ok = [h for h in self.history if h["valid"]]
        keys = OBJECTIVES if self.task.sees_power else ("latency_us", "area_um2")
        pts = [tuple(h[k] for k in keys) for h in ok]
        return [ok[i]["id"] for i in pareto.front(pts)]

    def state_text(self, focus: str) -> str:
        t = self.task
        lines = [f"GOAL: {t.goal()}", f"Budget: {self.oracle.left} of {t.budget} evaluations left."]
        if not self.history:
            lines.append("Nothing evaluated yet.")
            return "\n".join(lines)
        if t.kind in ("A", "B"):
            best = sorted(self.history, key=self._objective_key)[: t.top_k]
            lines.append(f"Best {len(best)} so far (by the goal):")
            lines += [f"  {self._fmt(h)}" for h in best]
        front = set(self.front_ids())
        lines.append(f"Current Pareto front ({len(front)} designs):")
        lines += [f"  {self._fmt(h)}" for h in self.history if h["id"] in front][: t.top_k]
        if focus == "performance":
            rest = sorted((h for h in self.history if h["valid"]), key=lambda h: h["latency_us"])[: t.top_k]
            lines.append("Fastest designs:")
            lines += [f"  {self._fmt(h)}" for h in rest]
        if focus == "power":
            rest = sorted((h for h in self.history if h["valid"]), key=lambda h: h["power_w"])[: t.top_k]
            lines.append("Lowest-power designs:")
            lines += [f"  {self._fmt(h)}" for h in rest]
        bad = [h for h in self.history if not h["valid"]]
        if bad:
            lines.append("Invalid configurations (do not repeat): " + ", ".join(h["id"] for h in bad))
        lines.append("Already evaluated (do not repeat): " + ", ".join(h["id"] for h in self.history))
        return "\n".join(lines)

    # ---------- LLM plumbing ----------
    def system(self) -> str:
        return SYSTEM.format(knobs=KNOB_DOC, hints=POWER_HINTS + "\n" if self.task.kind == "D" else "")

    def ask(self, role: str, prompt: str) -> dict | None:
        from langchain_core.messages import HumanMessage, SystemMessage
        msgs = [SystemMessage(self.system()), HumanMessage(prompt)]
        for attempt in range(2):
            start = time.monotonic()
            reply = self.llm.invoke(msgs)
            self.calls += 1
            usage = getattr(reply, "usage_metadata", None) or {}
            self.tokens_in += usage.get("input_tokens", 0)
            self.tokens_out += usage.get("output_tokens", 0)
            text = reply.content if isinstance(reply.content, str) else str(reply.content)
            self.transcript.append({"role": role, "attempt": attempt, "prompt": prompt, "reply": text,
                                    "seconds": round(time.monotonic() - start, 1)})
            obj, err = parse_reply(text, set(self.oracle.evaluated))
            if obj is not None:
                return obj
            self.retries += 1
            msgs = msgs + [reply, HumanMessage(f"Invalid answer: {err}. Reply again with one JSON object.")]
        return None

    def to_point(self, obj: dict | None) -> Point:
        if obj is None:
            self.fallbacks += 1
            return random_point(self.rng, set(self.oracle.evaluated))
        return obj["point"]


CONFIG_SCHEMA = ('{"mhz": <int>, "unroll": <int>, "mem": "<11|nn2|nn4>", "popt": <0|1>, "frac": <0|16>, '
                 '"reason": "<one sentence>"}')


def parse_reply(text: str, evaluated: set[str]) -> tuple[dict | None, str]:
    """The design point in an LLM reply ({"mhz":..} or {"config": {...}}), checked against the knob values."""
    m = re.search(r"\{.*\}", text, re.S)
    if not m:
        return None, "no JSON object found"
    try:
        obj = json.loads(m[0])
    except json.JSONDecodeError as e:
        return None, f"not valid JSON ({e.msg})"
    cfg = obj.get("config", obj)
    try:
        p = Point(int(cfg["mhz"]), int(cfg["unroll"]), str(cfg["mem"]), int(cfg["popt"]), int(cfg["frac"]))
    except (KeyError, TypeError, ValueError) as e:
        return None, f"missing or malformed knob ({e})"
    for name, val in p.__dict__.items():
        if val not in KNOBS[name]:
            return None, f"{name}={val!r} is not one of {list(KNOBS[name])}"
    if p.id in evaluated:
        return None, f"{p.id} was already evaluated; propose a new design"
    obj["point"] = p
    return obj, ""


def build_graph(run: Run):
    t = run.task

    def router(state: S) -> S:
        prompt = (run.state_text("router") + "\n\nPropose the FIRST design to evaluate, as JSON: " + CONFIG_SCHEMA)
        return {"next": {"point": run.to_point(run.ask("router", prompt)), "by": "router"}}

    def evaluate(state: S) -> S:
        p: Point = state["next"]["point"]
        try:
            obs = run.oracle.evaluate(p)
        except BudgetExhausted:
            return {}
        run.history.append(obs)
        return {"log": state.get("log", []) + [{"id": p.id, "by": state["next"]["by"]}]}

    def specialists(state: S) -> S:
        props = {}
        roles = ["performance"] + (["power"] if t.sees_power else [])
        for role in roles:
            what = ("lower latency (fewer cycles or a higher achieved clock)" if role == "performance"
                    else "lower power (and energy) without giving up the goal")
            prompt = (run.state_text(role) + f"\n\nYou are the {role.upper()} SPECIALIST. Propose ONE new design "
                      f"likely to achieve {what}. Answer as JSON: " + CONFIG_SCHEMA)
            props[role] = run.ask(role, prompt)
        return {"proposals": props}

    def arbitrator(state: S) -> S:
        props = {k: v for k, v in state["proposals"].items() if v is not None}
        if len(props) <= 1:  # nothing to arbitrate (agent A, or a specialist failed)
            role, obj = next(iter(props.items()), ("fallback", None))
            return {"next": {"point": run.to_point(obj), "by": role}}
        listing = "\n".join(f"- {k}: {v['point'].id} ({v.get('reason', '')})" for k, v in props.items())
        prompt = (run.state_text("arbitrator") + f"\n\nYou are the ARBITRATOR. The specialists propose:\n{listing}\n"
                  "Pick the one design (one of these, or a better new one) that best advances the goal given the "
                  "remaining budget. Answer as JSON: " + CONFIG_SCHEMA)
        obj = run.ask("arbitrator", prompt)
        if obj is None:  # fall back to a specialist's proposal rather than a random point
            role, obj = next(iter(props.items()))
            return {"next": {"point": obj["point"], "by": f"{role} (arbitrator failed)"}}
        return {"next": {"point": obj["point"], "by": "arbitrator"}}

    def more(state: S) -> str:
        return "specialists" if run.oracle.left > 0 else END

    g = StateGraph(S)
    g.add_node("router", router)
    g.add_node("evaluate", evaluate)
    g.add_node("specialists", specialists)
    g.add_node("arbitrator", arbitrator)
    g.set_entry_point("router")
    g.add_edge("router", "evaluate")
    g.add_conditional_edges("evaluate", more, {"specialists": "specialists", END: END})
    g.add_edge("specialists", "arbitrator")
    g.add_edge("arbitrator", "evaluate")
    return g.compile()


def run_agent(task: Task, oracle: Oracle, llm, seed: int = 0) -> Run:
    run = Run(task, oracle, llm, seed)
    build_graph(run).invoke({"log": []}, {"recursion_limit": 10 * task.budget + 20})
    return run
