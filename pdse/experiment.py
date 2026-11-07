"""Stage 3: the agent pilot on the offline oracle, with the non-LLM baselines at the same budget.

    python -m pdse.experiment [--kernel gemm_int32] [--tier p1g] [--budget 20] [--seeds 5]
                              [--agents A B C D] [--baselines random nsga2 greedy] [--baseline-seeds 50]
                              [--model devstral-small-2] [--num-ctx 32768] [--temperature 0.7]

Agents run on devstral through a local Ollama server (started if needed). Each run's evaluated ids, LLM transcript
and token counts go to runs/experiment/<tier>/<name>_seed<k>.json; the summary to data/<kernel>_<tier>_experiment.json.

Metrics per run (proposal Section 6.4):
  hv_coverage        hypervolume of the found valid designs / hypervolume of the whole space, (latency, area, power)
                     normalized to the space's min/max, reference point 1.1
  hv_curve           the same after each evaluation (for "calls to reach 90% of the final HV")
  best_latency_us    under the area cap (agent A's objective)
  best_power_iso_lat the lowest power among found designs with latency <= A's median best latency × 1.1
  invalid_evals      evaluations spent on invalid configurations
"""

from __future__ import annotations

import argparse
import json
import statistics
import time
from pathlib import Path

from .agents import Task, run_agent
from .baselines import BASELINES
from .oracle import Oracle, Space, load
from .space import ROOT


def hv_curve(space: Space, ids: list[str]) -> list[float]:
    out = []
    for n in range(1, len(ids) + 1):
        out.append(space.hv_coverage([i for i in ids[:n] if space.table[i]]))
    return out


def best_latency(space: Space, ids: list[str], area_cap: float) -> float | None:
    vals = [space.table[i]["latency_us"] for i in ids if space.table[i] and space.table[i]["area_um2"] <= area_cap]
    return min(vals) if vals else None


def best_power_within(space: Space, ids: list[str], lat_cap: float, area_cap: float) -> float | None:
    vals = [space.table[i]["power_w"] for i in ids
            if space.table[i] and space.table[i]["latency_us"] <= lat_cap and space.table[i]["area_um2"] <= area_cap]
    return min(vals) if vals else None


def summarize(space: Space, ids: list[str], area_cap: float, lat_cap: float) -> dict:
    curve = hv_curve(space, ids)
    final = curve[-1] if curve else 0.0
    to90 = next((n + 1 for n, v in enumerate(curve) if final and v >= 0.9 * final), None)
    return {"hv_coverage": round(final, 4), "hv_curve": [round(v, 4) for v in curve], "evals_to_90pct": to90,
            "best_latency_us": best_latency(space, ids, area_cap),
            "best_power_iso_lat_w": best_power_within(space, ids, lat_cap, area_cap),
            "invalid_evals": sum(1 for i in ids if not space.table[i]),
            "true_front_found": len(set(ids) & set(space.true_front()))}


def make_llm(model: str, num_ctx: int, temperature: float, seed: int):
    from langchain_ollama import ChatOllama
    return ChatOllama(model=model, num_ctx=num_ctx, temperature=temperature, seed=seed, num_predict=1024,
                      format="json", keep_alive=-1)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kernel", default="gemm_int32")
    ap.add_argument("--tier", default="p1g", choices=["p0", "p1", "p1g"])
    ap.add_argument("--budget", type=int, default=20)
    ap.add_argument("--seeds", type=int, default=5)
    ap.add_argument("--agents", nargs="*", default=["A", "B", "C", "D"])
    ap.add_argument("--baselines", nargs="*", default=list(BASELINES))
    ap.add_argument("--baseline-seeds", type=int, default=50)
    ap.add_argument("--model", default="devstral-small-2")
    ap.add_argument("--num-ctx", type=int, default=32768)
    ap.add_argument("--temperature", type=float, default=0.7)
    args = ap.parse_args()

    space = Space(load(ROOT / "data" / f"{args.kernel}_space.csv"), tier=args.tier)
    valid = space.valid()
    areas = sorted(space.table[i]["area_um2"] for i in valid)
    area_cap = areas[len(areas) // 2]  # median area: the "1000-LUT cap" of the proposal's pilot, on this space
    outdir = ROOT / "runs" / "experiment" / args.tier
    outdir.mkdir(parents=True, exist_ok=True)
    summary = {"kernel": args.kernel, "tier": args.tier, "budget": args.budget, "space_size": len(space.table),
               "valid": len(valid), "true_front_size": len(space.true_front()), "area_cap_um2": area_cap,
               "model": args.model, "temperature": args.temperature, "runs": {}}

    # agent A first: its best latency sets B's latency constraint and the iso-latency power metric
    lat_cap = None
    for kind in sorted(args.agents):
        if kind != "A" and lat_cap is None:
            a_best = [r["best_latency_us"] for name, r in summary["runs"].items() if name.startswith("agent_A")
                      and r["best_latency_us"]]
            # without A runs, use the oracle's best latency under the cap as the reference
            ref = statistics.median(a_best) if a_best else best_latency(space, valid, area_cap)
            lat_cap = ref * 1.1
            summary["lat_cap_us"] = lat_cap
        for seed in range(args.seeds):
            task = Task(kind, budget=args.budget, area_cap=area_cap, lat_cap=lat_cap or float("inf"))
            visible = (("latency_us", "area_um2", "cycles", "f_eff_mhz", "flip_flops") if kind == "A" else
                       ("latency_us", "area_um2", "power_w", "cycles", "f_eff_mhz", "flip_flops"))
            oracle = Oracle(space, budget=args.budget, visible=visible)
            start = time.monotonic()
            run = run_agent(task, oracle, make_llm(args.model, args.num_ctx, args.temperature, seed), seed=seed)
            name = f"agent_{kind}_seed{seed}"
            res = summarize(space, oracle.evaluated, area_cap, lat_cap or float("inf"))
            res |= {"ids": oracle.evaluated, "llm_calls": run.calls, "tokens_in": run.tokens_in,
                    "tokens_out": run.tokens_out, "retries": run.retries, "fallbacks": run.fallbacks,
                    "seconds": round(time.monotonic() - start, 1)}
            summary["runs"][name] = res
            (outdir / f"{name}.json").write_text(json.dumps(res | {"transcript": run.transcript}, indent=1))
            print(f"{name}: hv={res['hv_coverage']} lat={res['best_latency_us']} p@lat={res['best_power_iso_lat_w']} "
                  f"calls={run.calls} fallbacks={run.fallbacks} {res['seconds']}s", flush=True)
    if lat_cap is None:
        lat_cap = best_latency(space, valid, area_cap) * 1.1
        summary["lat_cap_us"] = lat_cap

    for b in args.baselines:
        for seed in range(args.baseline_seeds):
            oracle = Oracle(space, budget=args.budget)
            BASELINES[b](oracle, seed)
            summary["runs"][f"{b}_seed{seed}"] = summarize(space, oracle.evaluated, area_cap, lat_cap) | {
                "ids": oracle.evaluated}
        covs = [summary["runs"][f"{b}_seed{s}"]["hv_coverage"] for s in range(args.baseline_seeds)]
        print(f"{b}: median hv={statistics.median(covs):.3f}", flush=True)

    out = ROOT / "data" / f"{args.kernel}_{args.tier}_experiment.json"
    out.write_text(json.dumps(summary, indent=1))
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
