"""Offline oracle over an exhaustively evaluated design space (data/<kernel>_space.csv).

Agents and baselines "synthesize" a configuration by looking it up here; the budget counts unique configurations, as a
real synthesis call would. Every design is credited at the clock it can actually run at, f_eff = min(target, Fmax
from logic synthesis), so a design never benefits from a clock it misses:

    latency_us = cycles / f_eff
    power_w    = dynamic power (OpenSTA at the target clock) × f_eff / f_target + leakage   (for one power tier)
    energy_uj  = power_w × latency_us
    area_um2   = cell area after logic synthesis
"""

from __future__ import annotations

import csv
import random
from dataclasses import dataclass, field
from pathlib import Path

from . import pareto
from .space import KNOBS, Point

TIERS = ("p0", "p1", "p1g")
OBJECTIVES = ("latency_us", "area_um2", "power_w")


class BudgetExhausted(Exception):
    pass


def _f(r: dict, k: str) -> float | None:
    v = r.get(k)
    return float(v) if v not in (None, "") else None


def metrics(r: dict, tier: str) -> dict | None:
    """Objective values of one CSV row for a power tier, or None if the design is invalid."""
    if r.get("status") != "pass":
        return None
    cycles, mhz, fmax = _f(r, "cycles"), _f(r, "mhz"), _f(r, "fmax_mhz")
    dyn, leak = _f(r, f"{tier}_power_dynamic_w"), _f(r, f"{tier}_power_leakage_w")
    area = _f(r, "cell_area_um2")
    if None in (cycles, mhz, fmax, dyn, leak, area):
        return None
    f_eff = min(mhz, fmax)
    power = dyn * f_eff / mhz + leak
    latency = cycles / f_eff
    return {"latency_us": latency, "area_um2": area, "power_w": power, "energy_uj": power * latency,
            "f_eff_mhz": f_eff, "cycles": cycles, "meets_target_clock": fmax >= mhz,
            "flip_flops": _f(r, "flip_flops"), "cells": _f(r, "cells")}


def load(csv_path: Path) -> dict[str, dict]:
    with open(csv_path) as f:
        return {r["id"]: r for r in csv.DictReader(f)}


@dataclass
class Space:
    """All design points of one kernel with their metrics for one power tier (None = invalid configuration)."""
    rows: dict[str, dict]
    tier: str = "p1g"
    table: dict[str, dict | None] = field(init=False)

    def __post_init__(self):
        self.table = {pid: metrics(r, self.tier) for pid, r in self.rows.items()}

    def valid(self) -> list[str]:
        return [pid for pid, m in self.table.items() if m]

    def bounds(self, keys=OBJECTIVES) -> dict[str, tuple[float, float]]:
        vals = [m for m in self.table.values() if m]
        return {k: (min(v[k] for v in vals), max(v[k] for v in vals)) for k in keys}

    def norm(self, ids: list[str], keys=OBJECTIVES) -> list[tuple]:
        b = self.bounds(keys)
        return pareto.normalize([self.table[i] for i in ids if self.table[i]], keys, b)

    def true_front(self, keys=OBJECTIVES) -> list[str]:
        ids = self.valid()
        pts = [tuple(self.table[i][k] for k in keys) for i in ids]
        return [ids[j] for j in pareto.front(pts)]

    def hv(self, ids: list[str], keys=OBJECTIVES, ref: float = 1.1) -> float:
        return pareto.hypervolume(self.norm(ids, keys), (ref,) * len(keys))

    def hv_coverage(self, ids: list[str], keys=OBJECTIVES) -> float:
        best = self.hv(self.valid(), keys)
        return self.hv(ids, keys) / best if best else 0.0


@dataclass
class Oracle:
    """Budgeted lookups for one search run. `visible` decides which fields the searcher is shown."""
    space: Space
    budget: int = 20
    visible: tuple[str, ...] = ("latency_us", "area_um2", "power_w", "cycles", "f_eff_mhz", "flip_flops")
    evaluated: list[str] = field(default_factory=list)

    @property
    def left(self) -> int:
        return self.budget - len(self.evaluated)

    def evaluate(self, p: Point) -> dict:
        if p.id not in self.space.table:
            raise KeyError(p.id)
        if p.id not in self.evaluated:
            if self.left <= 0:
                raise BudgetExhausted
            self.evaluated.append(p.id)
        m = self.space.table[p.id]
        if m is None:
            return {"id": p.id, "valid": False}
        return {"id": p.id, "valid": True, **{k: m[k] for k in self.visible if k in m}}

    def valid_found(self) -> list[str]:
        return [i for i in self.evaluated if self.space.table[i]]


def random_point(rng: random.Random, exclude: set[str] = frozenset()) -> Point:
    while True:
        p = Point(*(rng.choice(v) for v in KNOBS.values()))
        if p.id not in exclude:
            return p
