"""Non-LLM search baselines on the oracle, at the same budget as the agents.

random   uniform sampling without replacement
nsga2    a small NSGA-II over the five discrete knobs (non-dominated sorting + crowding distance, uniform crossover,
         per-gene mutation); objectives = the oracle's (latency, area, power) (or a subset)
greedy   coordinate descent on a scalar (normalized sum of objectives): from a random start, try one-knob changes,
         move to the best improvement, restart randomly when stuck
All return the list of evaluated ids in order (Oracle.evaluated).
"""

from __future__ import annotations

import random

from . import pareto
from .oracle import OBJECTIVES, BudgetExhausted, Oracle, random_point
from .space import KNOBS, Point


def run_random(o: Oracle, seed: int) -> list[str]:
    rng = random.Random(seed)
    try:
        while o.left > 0:
            o.evaluate(random_point(rng, set(o.evaluated)))
    except BudgetExhausted:
        pass
    return o.evaluated


def _objs(o: Oracle, pid: str, keys) -> tuple | None:
    m = o.space.table.get(pid)
    if not m:
        return None
    b = o.space.bounds(keys)
    return tuple((m[k] - b[k][0]) / (b[k][1] - b[k][0]) for k in keys)


def _crowding(vals: list[tuple]) -> list[float]:
    n = len(vals)
    if n <= 2:
        return [float("inf")] * n
    d = [0.0] * n
    for k in range(len(vals[0])):
        order = sorted(range(n), key=lambda i: vals[i][k])
        d[order[0]] = d[order[-1]] = float("inf")
        span = vals[order[-1]][k] - vals[order[0]][k] or 1.0
        for a, b, c in zip(order, order[1:], order[2:]):
            d[b] += (vals[c][k] - vals[a][k]) / span
    return d


def _rank(ids: list[str], vals: list[tuple]) -> list[tuple[str, int, float]]:
    """(id, front rank, crowding) for each id; invalid designs get the worst rank."""
    remaining = list(range(len(ids)))
    out = []
    rank = 0
    while remaining:
        pts = [vals[i] for i in remaining]
        f = [remaining[j] for j in pareto.front(pts)] or remaining
        crowd = _crowding([vals[i] for i in f])
        out += [(ids[i], rank, c) for i, c in zip(f, crowd)]
        remaining = [i for i in remaining if i not in f]
        rank += 1
    return out


def run_nsga2(o: Oracle, seed: int, keys=OBJECTIVES, pop_size: int = 4) -> list[str]:
    rng = random.Random(seed)
    names = list(KNOBS)
    pop: list[Point] = []
    try:
        while len(pop) < pop_size:
            p = random_point(rng, set(o.evaluated))
            o.evaluate(p)
            pop.append(p)
        stall = 0
        while o.left > 0 and stall < 200:
            ids = [p.id for p in pop]
            vals = [_objs(o, i, keys) or (9.0,) * len(keys) for i in ids]
            ranked = {i: (r, -c) for i, r, c in _rank(ids, vals)}

            def tournament() -> Point:
                a, b = rng.sample(pop, 2)
                return a if ranked[a.id] <= ranked[b.id] else b

            children = []
            while len(children) < pop_size and o.left > 0 and stall < 200:
                pa, pb = tournament(), tournament()
                genes = [getattr(pa, n) if rng.random() < 0.5 else getattr(pb, n) for n in names]
                for g, n in enumerate(names):
                    if rng.random() < 1 / len(names):
                        genes[g] = rng.choice(KNOBS[n])
                child = Point(*genes)
                if child.id in o.evaluated:
                    stall += 1
                    continue
                o.evaluate(child)
                children.append(child)
                stall = 0
            merged = pop + children
            ids = [p.id for p in merged]
            vals = [_objs(o, i, keys) or (9.0,) * len(keys) for i in ids]
            order = sorted(_rank(ids, vals), key=lambda t: (t[1], -t[2]))
            keep = {i for i, _, _ in order[:pop_size]}
            pop = [p for p in merged if p.id in keep][:pop_size]
        while o.left > 0:  # GA converged on evaluated points: spend the rest randomly
            o.evaluate(random_point(rng, set(o.evaluated)))
    except BudgetExhausted:
        pass
    return o.evaluated


def run_greedy(o: Oracle, seed: int, keys=OBJECTIVES) -> list[str]:
    rng = random.Random(seed)
    names = list(KNOBS)

    def score(p: Point) -> float:
        v = _objs(o, p.id, keys)
        return sum(v) if v else float("inf")

    try:
        cur = random_point(rng, set(o.evaluated))
        o.evaluate(cur)
        while o.left > 0:
            neighbours = [Point(**{**cur.__dict__, n: v}) for n in names for v in KNOBS[n] if v != getattr(cur, n)]
            neighbours = [p for p in neighbours if p.id not in o.evaluated]
            rng.shuffle(neighbours)
            best = None
            for p in neighbours:
                o.evaluate(p)
                if score(p) < score(cur) and (best is None or score(p) < score(best)):
                    best = p
                    break  # first improvement
            if best is None:
                cur = random_point(rng, set(o.evaluated))
                o.evaluate(cur)
            else:
                cur = best
    except BudgetExhausted:
        pass
    return o.evaluated


BASELINES = {"random": run_random, "nsga2": run_nsga2, "greedy": run_greedy}
