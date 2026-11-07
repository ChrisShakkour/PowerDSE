# PowerDSE: is "Power-Aware Agentic HLS DSE" a viable thesis?

This repository evaluates the MSc thesis proposal *Closing the Power Feedback Gap in Agentic High-Level Synthesis*. It reproduces the proposal's pilot experiment (its Section 6) on an open-source ASIC flow, with a local LLM (devstral), and gives a go / reshape / no-go verdict through four gates.

| Gate | Question | Where |
|---|---|---|
| G1 Novelty | Does any agentic HLS DSE already use power in its loop? | [reports/claims_audit.md](reports/claims_audit.md) |
| G2 Signal | Does power carry information that latency, area and clock don't? | `python -m pdse.analyze` |
| G3 Fidelity | Are cheap power estimates good enough to steer a search? | `python -m pdse.analyze` |
| G4 Agent value | Does a power-aware devstral agent beat non-LLM search at 20 evaluations? | `python -m pdse.experiment`, then `pdse.analyze` |

The final verdict goes in `reports/verdict.md`.

## Flow

The proposal assumes Vitis HLS and Vivado power, which aren't installed here. As the audit found, Vitis C-synthesis reports no power anyway. This repo uses the open-source stack instead:

| Step | Tool | Module |
|---|---|---|
| HLS and C/RTL co-simulation (cycles, correctness) | Bambu 2024.10, device `asap7-TC`, Verilator 5.052 | `pdse/space.py` |
| Logic synthesis | Yosys 0.38 with Bambu's ASAP7 script, minus its broken adder extraction ([reports/flow_bug.md](reports/flow_bug.md)) | `pdse/synth.py` |
| Timing and power | OpenSTA inside OpenROAD 2.0 (`read_power_activities -vcd`) | `pdse/synth.py` |
| Gate-level co-simulation | Verilator, with cell models generated from the ASAP7 Liberty functions | `pdse/gatesim.py`, `cells/` |

**Power tiers** (all ASAP7 RVT TT, after logic synthesis, no place and route):
- **P0**, vectorless: default toggle rates. This is the "cheap estimate".
- **P1**, RTL activity: toggles from the RTL co-simulation, annotated on the roughly 7% of nets whose names survive synthesis. The rest is propagated.
- **P1g**, gate-level activity: toggles of every net, from simulating the netlist in Bambu's own testbench. **This is the reference.** The same simulation also proves the netlist correct.

Each co-simulation dumps a steady-state window of 50,000 cycles at the real clock period (`cells/sim_main.cpp`).

## Design space (pilot kernel: 64×64 int32 GEMM, `kernels/gemm_int32`)

| Knob | Values | Proposal's Vitis analogue |
|---|---|---|
| `mhz` | 250, 500, 750, 1000 | clock |
| `unroll` (`#pragma clang loop unroll_count`) | 1, 2, 4, 8 | UNROLL factor |
| `mem` (`--channels-type/number`) | 1, 2 or 4 memory ports | ARRAY_PARTITION |
| `popt` (`--power-optimization`) | 0, 1 | none |
| `frac` (`--DSP-fracturing=16`) | 0, 16 | none |

That is 192 points, matching the proposal's ≈180. Each design is credited at the clock it actually reaches, f_eff = min(target, Fmax): latency = cycles / f_eff, and dynamic power is scaled to f_eff (`pdse/oracle.py`).

## Agents (`pdse/agents.py`, LangGraph, devstral-small-2 via Ollama)

This follows the proposal's architecture: Router → evaluate → {Performance Specialist, Power Specialist} → Arbitrator → evaluate, and so on.
- LLM nodes have no tools and must answer with one JSON design point. Python validates it, gives one corrective retry, then falls back to a random point.
- Python owns the budget, the history (top-K) and the Pareto archive.
- Synthesis calls are lookups in the exhaustive table (`pdse/oracle.py`). The budget still counts unique designs, so runs take minutes and are reproducible.

| Agent | Sees | Goal |
|---|---|---|
| A | cycles, latency, area | Minimum latency under an area cap (the median area of the space) |
| B | + power | Minimum power with latency ≤ 1.1 × A's best |
| C | + power | Maximum (latency, area, power) hypervolume |
| D | C + a table of knob → power direction | Knowledge-gap ablation (proposal 6.6) |

**Baselines** at the same budget (`pdse/baselines.py`): random search, NSGA-II and greedy coordinate descent.

## Usage

```bash
conda activate atomrtl          # Python 3.12 with langgraph + langchain-ollama; EDA tools from the asic/eda envs
python -m pytest -q tests       # Pareto/HV, oracle, baselines, agent graph with a scripted LLM

# Stage 2: exhaustive sweep (hours; run in a detached tmux session)
tmux new -d -s sweep "python -m pdse.sweep --jobs 8 > logs/sweep.log 2>&1"
# Stage 3: agents (needs `ollama serve` with devstral-small-2) and baselines
tmux new -d -s exp "python -m pdse.experiment --tier p1g > logs/experiment.log 2>&1"
python -m pdse.analyze           # gates G2/G3/G4 -> data/gemm_int32_analysis.json
```
