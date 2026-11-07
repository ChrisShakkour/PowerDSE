"""Pareto dominance and exact hypervolume for minimization problems (any number of objectives; the slicing
algorithm is exact and fast enough for the few hundred points of a design space)."""

from __future__ import annotations

from typing import Sequence

Vec = Sequence[float]


def dominates(a: Vec, b: Vec) -> bool:
    return all(x <= y for x, y in zip(a, b)) and any(x < y for x, y in zip(a, b))


def front(points: list[Vec]) -> list[int]:
    """Indices of the non-dominated points (duplicates keep their first index only)."""
    keep = []
    seen = set()
    for i, p in enumerate(points):
        t = tuple(p)
        if t in seen:
            continue
        if not any(dominates(q, p) for j, q in enumerate(points) if j != i):
            keep.append(i)
            seen.add(t)
    return keep


def hypervolume(points: list[Vec], ref: Vec) -> float:
    """Volume dominated by `points` and bounded by `ref` (points not strictly better than ref in every objective are
    clipped away)."""
    pts = [tuple(p) for p in points if all(x < r for x, r in zip(p, ref))]
    if not pts:
        return 0.0
    pts = [pts[i] for i in front(pts)]
    return _hv(pts, tuple(ref))


def _hv(pts: list[tuple], ref: tuple) -> float:
    d = len(ref)
    if d == 1:
        return ref[0] - min(p[0] for p in pts)
    if d == 2:
        pts = sorted(pts)
        vol, best_y = 0.0, ref[1]
        for x, y in pts:
            if y < best_y:
                vol += (ref[0] - x) * (best_y - y)
                best_y = y
        return vol
    # slice along the last objective
    pts = sorted(pts, key=lambda p: p[-1])
    vol = 0.0
    for i, p in enumerate(pts):
        upper = pts[i + 1][-1] if i + 1 < len(pts) else ref[-1]
        if upper <= p[-1]:
            continue
        layer = [q[:-1] for q in pts[: i + 1]]
        layer = [layer[k] for k in front(layer)]
        vol += _hv(layer, ref[:-1]) * (upper - p[-1])
    return vol


def normalize(rows: list[dict], keys: Sequence[str], bounds: dict[str, tuple[float, float]]) -> list[tuple]:
    """Scale each objective to [0, 1] with fixed (min, max) bounds, so hypervolumes are comparable across runs."""
    return [tuple((r[k] - bounds[k][0]) / (bounds[k][1] - bounds[k][0]) for k in keys) for r in rows]
