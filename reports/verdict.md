# Verdict: "Power-Aware Agentic HLS Design Space Exploration"

**Recommendation: reshape, do not pursue as proposed.** The gap in the literature is real but narrow (G1). On the pilot kernel, power mostly follows area and clock (G2), so a free proxy steers the search as well as measured power does (G3). The devstral agents also lose to random search at the proposal's own 20-evaluation budget (G4). The evidence points to a different thesis: activity-aware power estimation, plus agents that use it to minimize **energy**, with a stronger LLM or a learned prior. See "What a viable thesis looks like" below.

The scope of this evaluation is limited. It covers one kernel (64×64 int32 GEMM), 192 design points, the Bambu HLS tool on the ASAP7 ASIC flow (not Vitis/FPGA, which the proposal assumes), logic synthesis only (no place and route), and one local LLM (devstral-small-2, 24B). Treat the numbers as a strong pilot, not a final answer.

## Setup

| | |
|---|---|
| Kernel | MachSuite `gemm_ncubed` with int32 elements, self-checking testbench (262,144 multiply-accumulates per call) |
| Knobs | clock 250/500/750/1000 MHz × inner-loop unroll 1/2/4/8 × memory ports 1/2/4 × `--power-optimization` × `--DSP-fracturing=16`, giving 192 points |
| Flow | Bambu 2024.10, then Yosys 0.38 (Bambu's ASAP7 script), then OpenSTA in OpenROAD. All 192 netlists were verified by gate-level co-simulation in Bambu's testbench. |
| Power | **P0** vectorless; **P1** RTL-simulation activity on the nets whose names survive synthesis; **P1g** gate-level simulation activity on every net (the reference). All ASAP7 RVT TT. |
| Objectives | latency = cycles / f_eff, where f_eff = min(target clock, Fmax); cell area; power scaled to f_eff |
| Search | budget of 20 unique designs on an offline oracle; agents A–D on devstral (5 seeds each); random, NSGA-II and greedy baselines (50 seeds each) |

## G1 Novelty: conditional pass (partly closed)

From [claims_audit.md](claims_audit.md):
- No LLM/agentic **HLS pragma** DSE uses power as feedback. MailoHLS (2026) even states that it excludes power.
- But LLM loops with power feedback already exist at **RTL**: VeriOpt (ICCAD'25), POET and ARES (2026).
- Power-aware HLS DSE without an LLM dates to 2020 (HL-Pow, PowerGear).

The proposal's premise that Vitis HLS gives per-configuration power at no cost is **not supported**: C synthesis reports no power. Several cited numbers need correcting (LLM-DSE's 2.55× is an arithmetic mean, not a geomean; HL-Pow's affiliation is wrong; check which Agent Factories version the 7.07× comes from).

## G2 Signal: fails as the proposal frames it

| Test (P1g reference, 192 designs) | Result | Pass threshold |
|---|---|---|
| Cross-validated R² of log power from log area + log clock | **0.976** (0.992 adding flip-flops, cells, cycles) | < 0.9: **fail** |
| 3-D Pareto points not on the 2-D (latency, area) front | 25 of 40 (62%) | ≥ 15%: pass |
| Median power spread among designs within ±10% latency and area | 33% | ≥ 20%: pass |
| Hypervolume of the 2-D front, judged in 3-D (power ignored entirely) | **0.961** | n/a |

Power reshapes the front, but almost only through area and clock, both of which the latency/area search already sees. Ignoring power entirely still keeps 96% of the 3-D hypervolume.

The knobs that "should" matter for power don't:
- **Bambu's `--power-optimization` changes nothing** on ASAP7: the netlists are identical.
- The real levers are clock (4.5× power from 250 to 1000 MHz) and unroll (2.7× from 1 to 8). Both are also latency/area levers.

**Energy is the more interesting objective.** It varies 3.3× (0.91–3.03 µJ per call), and the minimum-energy design (250 MHz, unroll 4, 2 memory ports) is neither the fastest nor the lowest-power one. Adding memory ports cuts energy by 23% (median) while adding area.

## G3 Fidelity: cheap power is good enough, and so is a free proxy

| Estimator vs P1g | Spearman | Mean ratio | Front Jaccard | HV of its front, judged by P1g |
|---|---|---|---|---|
| P0 vectorless (default activity) | 0.869 | 3.0× over | 0.47 | 0.993 |
| P1 RTL-activity annotation | 0.654 | 2.7× over | 0.38 | 0.972 |
| **area × clock proxy** (3 parameters) | **0.988** | 1.01 | 0.78 | **0.997** |
| no power (2-D front) | n/a | n/a | n/a | 0.961 |

- Absolute numbers from cheap estimates are far off: vectorless overstates power 3×.
- Annotating RTL activity on only the surviving net names is **worse** than no activity at all.
- Yet for *steering* (picking the front), even P0 recovers 99% of the hypervolume. A three-parameter area × clock fit does better still.

So the proposal's Q1 ("is the coarse estimate good enough?") has a clear answer: **yes, and power measurement itself is barely needed** for this kind of search.

## G4 Agent value: fails

Median hypervolume coverage of the true (latency, area, power) front after 20 evaluations:

| Searcher | Median HV (IQR) | Evals to 90% of its final HV | True-front designs found per run |
|---|---|---|---|
| Agent A (latency + area only) | 0.855 (0.787–0.867) | 17 | 4.6 |
| Agent B (minimize power under a latency cap) | 0.889 (0.798–0.932) | 13 | 1.0 |
| Agent C (3-D Pareto) | 0.863 (0.818–0.887) | 13 | 1.8 |
| Agent D (C plus a knob→power hint table) | 0.875 (0.869–0.881) | 14 | 2.0 |
| Random | 0.940 (0.928–0.948) | 6 | 2.8 |
| NSGA-II | 0.934 (0.907–0.947) | 5 | n/a |
| Greedy coordinate | **0.958** (0.926–0.969) | 8 | 4.0 |

Mann-Whitney tests:
- "Agent > baseline" has p ≥ 0.98 for every agent against every baseline. The baselines are clearly better.
- B, C and D against A: p = 0.13–0.30, so no significant gain from showing power.

The proposal's "power at iso-latency" metric is degenerate here: only one design meets both the area cap and the latency cap.

**Why the agents lose** (from the evaluated designs and their transcripts):
1. **Strong, wrong priors.** The agents pile onto unroll 8 and 4 memory ports. The power-aware agents B/C/D try 250 MHz in only 4–8% of evaluations, though 250 MHz designs make up 30% of the true front.
2. **They believe the documentation.** B/C/D turn on `--power-optimization` 82–90% of the time to "reduce power". It is a no-op, so they spend evaluations on duplicate designs.
3. **Little diversity.** With 20 evaluations, broad coverage beats directed reasoning, and the agents converge too early.

The prompt-hint ablation (D) narrowed the spread but didn't raise the median. That points to a reasoning and exploration gap rather than a knowledge gap (proposal 6.6).

## Answers to the proposal's questions (pilot)

| | Answer |
|---|---|
| **Q1** Fidelity | Coarse estimates rank designs well enough to steer (99% HV), though absolute values are off by 3×. Partial RTL activity is worse than none. |
| **Q2** Different configurations? | Yes, but not better ones. Power-aware agents choose different designs (more fracturing, power-optimization, mid clocks) and find fewer true-front points. |
| **Q3** Do they learn power-efficient patterns? | No. They kept turning on a power option that has no effect, and never discovered that a low clock with moderate unroll minimizes energy. |
| **Q4** Search efficiency | Hurt. The power objective did not help pruning; every agent was slower than random to reach 90% of its final HV. |

## What a viable thesis looks like (reshape options)

1. **Optimize energy and EDP, not power.** In this space, energy is the objective that area × clock doesn't already determine: 3.3× range, a distinct optimum, and memory ports cutting it by 23%. Agents should be scored on energy per operation, under latency SLAs.
2. **Make power fidelity the research contribution (proposal fallback 6.6).** This pilot shows vectorless power is 3× off and naive RTL-activity annotation is worse than nothing, while gate-level activity costs about 1 minute per design. A fast, activity-aware estimator would be a solid, novel, and measurable contribution: e.g. learned from RTL toggles, or a PowerGear-style GNN on the HLS IR, validated against the P1g pipeline built here (`pdse/gatesim.py`).
3. **If it must be agentic, fix the search, not the objective.**
   - Give the agent memory and diversity: initialize from a random or space-filling batch; let the LLM propose only after it has seen real data.
   - Ground the knob documentation by measuring each knob's effect first; the `--power-optimization` no-op would have been caught that way.
   - Compare against random, greedy and NSGA-II at equal budgets. LLM-DSE's own evaluation compares against AutoDSE and HARP, not random.
   - Test a stronger model (devstral-small-2 is 24B) before drawing model-level conclusions.
4. **Broaden before committing.**
   - Add 3–4 HLSyn/PolyBench kernels with richer design spaces (array partitioning, dataflow), where pragma choice changes switching activity, not just size.
   - Run a 20-point post-route (P2) check of P1g.

## Reproduce

```bash
cd ~/workspace/git/PowerDSE && conda activate atomrtl
python -m pdse.sweep --jobs 12                  # ~2 h, data/gemm_int32_space.csv (committed)
python -m pdse.experiment --tier p1g            # ~50 min with devstral on one RTX 3090
python -m pdse.analyze                          # data/gemm_int32_analysis.json
```

Not done (open items): post-route P2 validation, additional kernels, a stronger LLM, and a Vitis/FPGA comparison (no license on this host).
