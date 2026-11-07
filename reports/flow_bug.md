# Bambu's ASAP7 logic-synthesis script produces wrong adders with Yosys 0.38

**Found:** 2026-11-07, while building the gate-level power reference (tier P1g).

## Symptom

The gate-level netlist of `gemm_int32` failed Bambu's co-simulation: all 4,096 outputs read 0. A lock-step Icarus comparison with the RTL showed identical control behaviour but wrong memory addresses, starting from the first access. Even a bare `assign s = a + b;` synthesized with the same script came out wrong: `0x12153524 + 0xc0895e81` gave `0x87cbc6f3` instead of `0xd29e93a5`. Yosys's own `eval` of the netlist, which uses the Liberty cell functions, gave the same wrong value, so the netlist is wrong and the simulator is not to blame.

## Cause

When `ADDER_MAP_FILE` is set, `panda/scripts/synth.tcl` runs `extract_fa` and then Bambu's FA/HA techmap (`panda/asap7/yoSys/cells_adders.v`). A SAT miter of `a + b` against the result:

| Flow after `synth` | SAT equivalence |
|---|---|
| `techmap; opt` | proven equivalent |
| `extract_fa; techmap; opt` (Yosys's generic `$fa` model, no Bambu map) | **fails** |

So the bug is in `extract_fa` in this Yosys build: `litex-hub::yosys=0.38_93_g84116c9a3`. Bambu's techmap polarity checks out against the ASAP7 Liberty functions (`CON = !maj`, `SN = !xor`).

## Fix in this repo

`pdse/synth.py` does not set `ADDER_MAP_FILE`. Adders then go through Yosys's generic techmap and ABC. The 32-bit test passes 6,000 random vectors, and every design point's netlist is checked by gate-level co-simulation (`pdse/gatesim.py`, column `gl_status`). Any `netlist_mismatch` is excluded from the analysis.

## Impact on earlier results

The logic-synthesis numbers in `experaments/hls_synth` came from `logic_synth.py`, which sets `ADDER_MAP_FILE`. Those netlists were functionally wrong, so their Fmax, cell counts, area and power are not valid. That covers:
- the Bambu stencil designs at 1000 and 1500 MHz;
- all the XLS designs.

Their HLS-level numbers (cycles, co-simulation, Bambu's estimates) are unaffected. On the adder test, the wrong netlist was 42% smaller than the correct one (300 vs. 518 µm²), so the earlier areas were understated. Their critical paths were full-adder chains, so the earlier Fmax figures are not trustworthy either.

Bambu's own full flow (`--evaluation` with OpenROAD) uses the same script and would have the same problem with this Yosys version.
