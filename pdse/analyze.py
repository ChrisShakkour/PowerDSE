"""Gates G2 (does power carry information beyond latency/area/clock?) and G3 (are cheap power estimates faithful?)
on the exhaustive design space, plus the G4 summary of an agent experiment. Pure Python (no numpy).

    python -m pdse.analyze [--kernel gemm_int32] [--ref p1g]
Writes reports/<kernel>_analysis.md and data/<kernel>_analysis.json.
"""

from __future__ import annotations

import argparse
import json
import math
import random
import statistics
from pathlib import Path

from . import pareto
from .oracle import OBJECTIVES, Space, load
from .space import ROOT


# ---------------- statistics helpers ----------------
def ranks(v: list[float]) -> list[float]:
    order = sorted(range(len(v)), key=v.__getitem__)
    r = [0.0] * len(v)
    i = 0
    while i < len(order):
        j = i
        while j + 1 < len(order) and v[order[j + 1]] == v[order[i]]:
            j += 1
        for k in range(i, j + 1):
            r[order[k]] = (i + j) / 2 + 1
        i = j + 1
    return r


def pearson(x: list[float], y: list[float]) -> float:
    mx, my = statistics.fmean(x), statistics.fmean(y)
    sx = math.sqrt(sum((a - mx) ** 2 for a in x))
    sy = math.sqrt(sum((b - my) ** 2 for b in y))
    return sum((a - mx) * (b - my) for a, b in zip(x, y)) / (sx * sy) if sx and sy else float("nan")


def spearman(x, y):
    return pearson(ranks(x), ranks(y))


def kendall(x, y):
    n, c, d = len(x), 0, 0
    for i in range(n):
        for j in range(i + 1, n):
            s = (x[i] - x[j]) * (y[i] - y[j])
            c += s > 0
            d += s < 0
    return (c - d) / (c + d) if c + d else float("nan")


def lstsq(X: list[list[float]], y: list[float]) -> list[float]:
    """Ordinary least squares by normal equations + Gaussian elimination (small dense problems)."""
    k = len(X[0])
    A = [[sum(r[i] * r[j] for r in X) for j in range(k)] for i in range(k)]
    b = [sum(r[i] * t for r, t in zip(X, y)) for i in range(k)]
    for i in range(k):
        A[i][i] += 1e-9
    for c in range(k):
        p = max(range(c, k), key=lambda r: abs(A[r][c]))
        A[c], A[p], b[c], b[p] = A[p], A[c], b[p], b[c]
        for r in range(c + 1, k):
            f = A[r][c] / A[c][c]
            for j in range(c, k):
                A[r][j] -= f * A[c][j]
            b[r] -= f * b[c]
    w = [0.0] * k
    for i in reversed(range(k)):
        w[i] = (b[i] - sum(A[i][j] * w[j] for j in range(i + 1, k))) / A[i][i]
    return w


def cv_r2(X, y, folds=5, seed=0) -> float:
    idx = list(range(len(y)))
    random.Random(seed).shuffle(idx)
    pred = [0.0] * len(y)
    for f in range(folds):
        test = set(idx[f::folds])
        tr = [i for i in idx if i not in test]
        w = lstsq([X[i] for i in tr], [y[i] for i in tr])
        for i in test:
            pred[i] = sum(a * b for a, b in zip(w, X[i]))
    my = statistics.fmean(y)
    ss = sum((a - my) ** 2 for a in y)
    return 1 - sum((a - p) ** 2 for a, p in zip(y, pred)) / ss if ss else float("nan")


def mannwhitney_p(a: list[float], b: list[float]) -> float:
    """One-sided P(a > b) Mann-Whitney U, normal approximation (fine for n >= 5)."""
    n1, n2 = len(a), len(b)
    r = ranks(a + b)
    u = sum(r[:n1]) - n1 * (n1 + 1) / 2
    mu, sd = n1 * n2 / 2, math.sqrt(n1 * n2 * (n1 + n2 + 1) / 12)
    z = (u - mu) / sd if sd else 0.0
    return 0.5 * math.erfc(z / math.sqrt(2))


# ---------------- G2 / G3 ----------------
def g2(space: Space) -> dict:
    """Is power explained by area, flip-flops and clock? Does it change the Pareto front?"""
    ids = space.valid()
    m = [space.table[i] for i in ids]
    y = [math.log(r["power_w"]) for r in m]
    feats = {
        "area×f": [[1, math.log(r["area_um2"]), math.log(r["f_eff_mhz"])] for r in m],
        "area, flip-flops, cells, f, cycles": [[1, math.log(r["area_um2"]), math.log(r["flip_flops"] or 1),
                                                math.log(r["cells"]), math.log(r["f_eff_mhz"]),
                                                math.log(r["cycles"])] for r in m],
    }
    r2 = {k: round(cv_r2(X, y), 4) for k, X in feats.items()}
    f2 = set(space.true_front(("latency_us", "area_um2")))
    f3 = set(space.true_front(OBJECTIVES))
    off = sorted(f3 - f2)
    # power spread among near-equivalent designs (latency and area within ±10% of each other)
    spreads = []
    for a in m:
        group = [b["power_w"] for b in m if abs(b["latency_us"] / a["latency_us"] - 1) <= 0.1
                 and abs(b["area_um2"] / a["area_um2"] - 1) <= 0.1]
        if len(group) >= 2:
            spreads.append(max(group) / min(group) - 1)
    energy = [r["energy_uj"] for r in m]
    return {"valid": len(ids), "cv_r2_log_power": r2, "front2d": len(f2), "front3d": len(f3),
            "front3d_off_2d": len(off), "front3d_off_2d_frac": round(len(off) / len(f3), 3) if f3 else None,
            "off_2d_ids": off, "iso_lat_area_groups": len(spreads),
            "iso_lat_area_power_spread_median": round(statistics.median(spreads), 3) if spreads else None,
            "iso_lat_area_power_spread_max": round(max(spreads), 3) if spreads else None,
            "energy_uj_range": [min(energy), max(energy)]}


def proxy_rows(rows: dict, ref: str) -> dict:
    """A free power proxy: the reference power fitted (log-linear, all points) from area and achieved clock only.
    If steering by this proxy is as good as steering by measured power, power adds nothing beyond area x clock."""
    sref = Space(rows, ref)
    ids = sref.valid()
    X = [[1, math.log(sref.table[i]["area_um2"]), math.log(sref.table[i]["f_eff_mhz"])] for i in ids]
    w = lstsq(X, [math.log(sref.table[i]["power_w"]) for i in ids])
    out = {}
    for pid, r in rows.items():
        r2 = dict(r)
        m = sref.table.get(pid)
        if m:
            pw = math.exp(w[0] + w[1] * math.log(m["area_um2"]) + w[2] * math.log(m["f_eff_mhz"]))
            mhz = float(r["mhz"])
            # store as a tier whose dynamic power at the target clock gives pw at f_eff (see oracle.metrics)
            r2["proxy_power_dynamic_w"] = pw * mhz / m["f_eff_mhz"]
            r2["proxy_power_leakage_w"] = 0.0
        out[pid] = r2
    return out


def g3(rows: dict, ref: str, cheap: list[str]) -> dict:
    out = {}
    if "proxy" in cheap:
        rows = proxy_rows(rows, ref)
    sref = Space(rows, ref)
    for t in cheap:
        st = Space(rows, t)
        ids = [i for i in sref.valid() if st.table.get(i)]
        a = [sref.table[i]["power_w"] for i in ids]
        b = [st.table[i]["power_w"] for i in ids]
        fr, ft = set(sref.true_front()), set(st.true_front())
        # what a search guided by tier t would keep, judged by the reference tier
        hv_t_on_ref = sref.hv_coverage(sorted(ft))
        # the 2-D (latency, area) front alone, judged in 3-D by the reference: what ignoring power keeps
        hv_2d = sref.hv_coverage(sorted(sref.true_front(("latency_us", "area_um2"))))
        out[t] = {"n": len(ids), "pearson": round(pearson(a, b), 4), "spearman": round(spearman(a, b), 4),
                  "kendall": round(kendall(a, b), 4),
                  "mean_ratio_to_ref": round(statistics.fmean(x / y for x, y in zip(b, a)), 3),
                  "front_jaccard": round(len(fr & ft) / len(fr | ft), 3) if fr | ft else None,
                  "hv_of_its_front_under_ref": round(hv_t_on_ref, 4),
                  "front_size": len(ft), "hv_of_2d_front_under_ref": round(hv_2d, 4)}
    return out


# ---------------- report ----------------
def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kernel", default="gemm_int32")
    ap.add_argument("--ref", default="p1g", help="reference power tier")
    args = ap.parse_args()
    rows = load(ROOT / "data" / f"{args.kernel}_space.csv")
    statuses: dict[str, int] = {}
    for r in rows.values():
        statuses[r.get("status", "?")] = statuses.get(r.get("status", "?"), 0) + 1
    ref = Space(rows, args.ref)
    res = {"kernel": args.kernel, "points": len(rows), "statuses": statuses, "ref_tier": args.ref,
           "g2": g2(ref), "g3": g3(rows, args.ref, [t for t in ("p0", "p1", "proxy") if t != args.ref])}

    exp_path = ROOT / "data" / f"{args.kernel}_{args.ref}_experiment.json"
    if exp_path.exists():
        exp = json.loads(exp_path.read_text())
        from .experiment import summarize
        lat_cap, area_cap = exp["lat_cap_us"], exp["area_cap_um2"]
        groups: dict[str, list[dict]] = {}
        for name, r in exp["runs"].items():  # recompute every run's metrics with the same caps
            r = r | summarize(ref, r["ids"], area_cap, lat_cap)
            groups.setdefault(name.rsplit("_seed", 1)[0], []).append(r)
        g4 = {}
        for name, rs in groups.items():
            hv = [r["hv_coverage"] for r in rs]
            piso = [r["best_power_iso_lat_w"] for r in rs if r.get("best_power_iso_lat_w")]
            lat = [r["best_latency_us"] for r in rs if r.get("best_latency_us")]
            ener = [min((ref.table[i]["energy_uj"] for i in r["ids"] if ref.table[i]), default=None) for r in rs]
            g4[name] = {"runs": len(rs), "hv_median": round(statistics.median(hv), 4),
                        "hv_iqr": [round(sorted(hv)[len(hv) // 4], 4), round(sorted(hv)[3 * len(hv) // 4], 4)],
                        "best_latency_us_median": round(statistics.median(lat), 1) if lat else None,
                        "runs_meeting_latency_cap": sum(1 for r in rs if r.get("best_power_iso_lat_w")),
                        "min_energy_uj_median": round(statistics.median([e for e in ener if e]), 4),
                        "hv_mean": round(statistics.fmean(hv), 4),
                        "best_power_iso_lat_mw_median": round(statistics.median(piso) * 1e3, 4) if piso else None,
                        "evals_to_90pct_median": statistics.median([r["evals_to_90pct"] or 0 for r in rs]),
                        "invalid_evals_mean": round(statistics.fmean(r["invalid_evals"] for r in rs), 2),
                        "fallbacks_mean": round(statistics.fmean(r.get("fallbacks", 0) for r in rs), 2)}
        tests = {}
        for ag in [g for g in groups if g.startswith("agent_")]:
            for bl in [g for g in groups if not g.startswith("agent_")] + ["agent_A"]:
                if bl == ag or bl not in groups:
                    continue
                tests[f"{ag} > {bl}"] = round(mannwhitney_p([r["hv_coverage"] for r in groups[ag]],
                                                            [r["hv_coverage"] for r in groups[bl]]), 4)
        res["g4"] = {"area_cap_um2": exp["area_cap_um2"], "lat_cap_us": exp.get("lat_cap_us"),
                     "budget": exp["budget"], "groups": g4, "mannwhitney_p_hv": tests}

    (ROOT / "data" / f"{args.kernel}_analysis.json").write_text(json.dumps(res, indent=1))
    print(json.dumps(res, indent=1))


if __name__ == "__main__":
    main()
