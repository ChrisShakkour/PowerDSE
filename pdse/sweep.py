"""Exhaustive evaluation of a kernel's design space (Stage 2): every point through Bambu, co-simulation, logic
synthesis, P0/P1/P1g power. Results merge into data/<kernel>_space.csv by point id, so the sweep can be resumed.

    python -m pdse.sweep [--kernel gemm_int32] [--jobs 8] [--only ID ...] [--limit N] [--work /var/tmp/pdse]
Run it in a detached tmux session (each point takes minutes; the full space hours).
"""

from __future__ import annotations

import argparse
import csv
import random
import sys
import time
import traceback
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

from .space import GEMM_INT32, ROOT, Point, all_points, evaluate

KERNELS = {"gemm_int32": GEMM_INT32}


def load(path: Path) -> dict[str, dict]:
    if not path.exists():
        return {}
    with open(path) as f:
        return {r["id"]: r for r in csv.DictReader(f)}


def save(path: Path, rows: dict[str, dict]) -> None:
    fields: list[str] = []
    for r in rows.values():
        fields += [k for k in r if k not in fields]
    tmp = path.with_suffix(".tmp")
    with open(tmp, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(sorted(rows.values(), key=lambda r: r["id"]))
    tmp.replace(path)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kernel", default="gemm_int32", choices=list(KERNELS))
    ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--only", nargs="*", help="point ids to (re)run")
    ap.add_argument("--limit", type=int, help="run at most N not-yet-done points (random order)")
    ap.add_argument("--redo", action="store_true", help="rerun points that already have a row")
    ap.add_argument("--work", type=Path, default=Path("/var/tmp/pdse"), help="local scratch for tool runs")
    args = ap.parse_args()

    k = KERNELS[args.kernel]
    out = ROOT / "data" / f"{k.name}_space.csv"
    rows = load(out)
    todo = [Point.from_id(i) for i in args.only] if args.only else all_points()
    if not args.redo and not args.only:
        todo = [p for p in todo if p.id not in rows]
    random.Random(0).shuffle(todo)
    if args.limit:
        todo = todo[: args.limit]
    print(f"{len(todo)} points to run, {len(rows)} already in {out}", flush=True)

    start = time.monotonic()
    with ThreadPoolExecutor(args.jobs) as pool:
        futs = {pool.submit(evaluate, k, p, args.work): p for p in todo}
        for n, fut in enumerate(as_completed(futs), 1):
            p = futs[fut]
            try:
                r = fut.result()
            except Exception:
                r = {"kernel": k.name, "id": p.id, **p.__dict__, "status": "crash",
                     "error": traceback.format_exc()[-300:]}
            rows[p.id] = r
            save(out, rows)
            el = time.monotonic() - start
            print(f"[{n}/{len(todo)}] {p.id}: {r.get('status')} cycles={r.get('cycles')} fmax={r.get('fmax_mhz')} "
                  f"p0={r.get('p0_power_total_w')} p1={r.get('p1_power_total_w')} p1g={r.get('p1g_power_total_w')} "
                  f"({el / 60:.1f} min elapsed)", flush=True)


if __name__ == "__main__":
    sys.exit(main())
