"""Pareto/hypervolume, oracle budget and baselines on a synthetic design space (no EDA tools, no LLM)."""

import itertools
import random

import pytest

from pdse import pareto
from pdse.baselines import BASELINES
from pdse.oracle import BudgetExhausted, Oracle, Space
from pdse.space import Point, all_points


def synthetic_rows(seed=0, invalid_every=17):
    """A plausible fake space: unroll cuts cycles and adds area/power, clock raises power, some points invalid."""
    rng = random.Random(seed)
    rows = {}
    for i, p in enumerate(all_points()):
        ok = i % invalid_every != 5
        cycles = 700_000 / p.unroll * (1.2 if p.mem == "11" else 1.0) * rng.uniform(0.95, 1.05)
        area = 1000 * (1 + 0.6 * p.unroll) * (1.1 if p.mem == "nn4" else 1.0) * (1.05 if p.frac else 1)
        fmax = min(1200, 650 + 100 * p.frac / 16) * rng.uniform(0.9, 1.1)
        dyn = 1e-5 * area * p.mhz / 1000 * (0.85 if p.popt else 1.0)
        rows[p.id] = {"id": p.id, "status": "pass" if ok else "hls_fail", "cycles": cycles, "mhz": p.mhz,
                      "fmax_mhz": fmax, "cell_area_um2": area, "p1g_power_dynamic_w": dyn,
                      "p1g_power_leakage_w": 1e-9 * area, "flip_flops": 100, "cells": 1000}
    return rows


def test_hypervolume_matches_grid_count():
    rng = random.Random(1)
    for _ in range(200):
        d = rng.choice([2, 3])
        pts = [tuple(rng.randint(0, 6) for _ in range(d)) for _ in range(rng.randint(1, 8))]
        cells = sum(1 for c in itertools.product(range(7), repeat=d)
                    if any(all(p[k] <= c[k] for k in range(d)) for p in pts))
        assert pareto.hypervolume(pts, (7,) * d) == pytest.approx(cells)


def test_front_drops_dominated_and_duplicates():
    pts = [(1, 2), (2, 1), (2, 2), (1, 2), (3, 3)]
    assert pareto.front(pts) == [0, 1]


def test_point_id_roundtrip():
    for p in all_points():
        assert Point.from_id(p.id) == p
    assert len(all_points()) == 192


def test_oracle_budget_and_repeats():
    o = Oracle(Space(synthetic_rows()), budget=3)
    p = all_points()[0]
    o.evaluate(p)
    o.evaluate(p)  # a repeat is free
    o.evaluate(all_points()[1])
    o.evaluate(all_points()[2])
    with pytest.raises(BudgetExhausted):
        o.evaluate(all_points()[3])
    assert o.left == 0


def test_full_space_has_coverage_one():
    s = Space(synthetic_rows())
    assert s.hv_coverage(s.valid()) == pytest.approx(1.0)
    assert s.hv_coverage(s.true_front()) == pytest.approx(1.0)


@pytest.mark.parametrize("name", list(BASELINES))
def test_baselines_spend_exact_budget_without_repeats(name):
    s = Space(synthetic_rows())
    for seed in range(5):
        o = Oracle(s, budget=20)
        ids = BASELINES[name](o, seed)
        assert len(ids) == 20 and len(set(ids)) == 20
        assert 0 <= s.hv_coverage(o.valid_found()) <= 1


def test_random_coverage_grows_with_budget():
    s = Space(synthetic_rows())
    mean = {}
    for b in (5, 40, 120):
        cov = []
        for seed in range(10):
            o = Oracle(s, budget=b)
            BASELINES["random"](o, seed)
            cov.append(s.hv_coverage(o.valid_found()))
        mean[b] = sum(cov) / len(cov)
    assert mean[5] < mean[40] < mean[120] <= 1.0
