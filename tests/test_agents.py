"""The agent graph with a scripted LLM: budget, JSON validation, retries, fallbacks, and what each agent sees."""

import json
import random

from langchain_core.messages import AIMessage

from pdse.agents import Task, parse_reply, run_agent
from pdse.oracle import Oracle, Space
from pdse.space import all_points
from tests.test_core import synthetic_rows


class ScriptedLLM:
    """Replies from a function of the prompt; records every prompt."""

    def __init__(self, fn):
        self.fn, self.prompts = fn, []

    def invoke(self, msgs):
        self.prompts.append(msgs[-1].content)
        return AIMessage(content=self.fn(msgs[-1].content, len(self.prompts)))


def random_json(seed=0):
    rng = random.Random(seed)
    pts = all_points()

    def fn(prompt, n):
        p = rng.choice(pts)
        return json.dumps({"mhz": p.mhz, "unroll": p.unroll, "mem": p.mem, "popt": p.popt, "frac": p.frac,
                           "reason": "test"})
    return fn


def test_parse_reply_checks_values_and_repeats():
    ok, err = parse_reply('blah {"mhz": 500, "unroll": 2, "mem": "nn2", "popt": 0, "frac": 16} blah', set())
    assert ok and ok["point"].id == "500MHz_u2_mnn2_po0_df16"
    assert parse_reply('{"mhz": 600, "unroll": 2, "mem": "nn2", "popt": 0, "frac": 0}', set())[0] is None
    assert parse_reply('{"config": {"mhz": 500, "unroll": 2, "mem": "11", "popt": 0, "frac": 0}}', set())[0]
    assert "already evaluated" in parse_reply('{"mhz": 500, "unroll": 2, "mem": "11", "popt": 0, "frac": 0}',
                                              {"500MHz_u2_m11_po0_df0"})[1]
    assert parse_reply("no json here", set())[0] is None


def test_agent_c_spends_budget_and_sees_power():
    space = Space(synthetic_rows())
    llm = ScriptedLLM(random_json(1))
    run = run_agent(Task("C", budget=12), Oracle(space, budget=12), llm, seed=0)
    assert len(run.oracle.evaluated) == 12 and len(set(run.oracle.evaluated)) == 12
    assert any("power=" in p for p in llm.prompts[2:])
    assert any("POWER SPECIALIST" in p for p in llm.prompts)


def test_agent_a_never_sees_power():
    space = Space(synthetic_rows())
    llm = ScriptedLLM(random_json(2))
    run = run_agent(Task("A", budget=10, area_cap=3000), Oracle(space, budget=10), llm)
    assert len(run.oracle.evaluated) == 10
    assert not any("power=" in p or "POWER SPECIALIST" in p for p in llm.prompts)


def test_garbage_replies_fall_back_to_random_points():
    space = Space(synthetic_rows())
    llm = ScriptedLLM(lambda prompt, n: "I think unrolling is good.")
    run = run_agent(Task("C", budget=6), Oracle(space, budget=6), llm)
    assert len(run.oracle.evaluated) == 6
    assert run.fallbacks >= 1 and run.retries >= run.fallbacks
