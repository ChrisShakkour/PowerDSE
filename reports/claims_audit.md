# Stage 0: claims audit and novelty check (gate G1)

As of 2026-11-07. This audit was done with web search and the papers' own text, mostly arXiv HTML. Where a paper was checked only at abstract level, the table says so.

## 1. Novelty: is power used as feedback in LLM or agentic optimization loops?

### A. LLM/agentic HLS design-space exploration (the gap the thesis claims)

| Work | How power is used |
|---|---|
| LLM-DSE ([2505.12188](https://arxiv.org/html/2505.12188v2)) | Not used. Objective is latency (cycles), with resources kept under 80%. |
| Agent Factories, IBM ([2603.25719](https://arxiv.org/html/2603.25719v2)) | Never mentioned. The only cost metric is tokens. |
| A3D, Purdue/Argonne/UChicago ([2605.15237](https://arxiv.org/html/2605.15237)) | Reported after the fact only. The design-space Pareto front is latency vs. area, even though its simulator estimates energy for each design point. |
| Intelligent4DSE / ECoGNN-LLMMH ([2504.19649](https://arxiv.org/html/2504.19649)) | **Near miss.** Frames the problem as PPA, and its GNN predicts post-implementation power. But the LLM fitness and the ADRS score use only latency and LUT/FF/DSP/BRAM. |
| MPM-LLM4DSE ([2601.04801](https://arxiv.org/html/2601.04801)) | Latency and resources only. Cites PowerGear without using it. |
| MailoHLS, NTUA ([2606.07246](https://arxiv.org/html/2606.07246v1)) | Excludes power explicitly: "GNΩSIS does not provide power measurements, and thus power is not considered as an optimization objective". **Direct evidence that the gap exists.** |
| iDSE ([2505.22086](https://arxiv.org/abs/2505.22086)) | Latency plus a weighted sum of resources. |
| AHRR, Ding/Cong ([2609.21157](https://arxiv.org/abs/2609.21157)) | Speedup only (abstract checked). |
| FPGAgent ([2608.23630](https://arxiv.org/abs/2608.23630)) | Correctness and synthesizability only (abstract checked). |
| From Pragmas to Partners ([2602.01401](https://arxiv.org/html/2602.01401)) | Mentions "low power" once, as a design goal. |
| Can Reasoning Models… (NYU, [2503.12721](https://arxiv.org/html/2503.12721v1)) | Latency under an area constraint (from a search summary; not read in full). |

### B. LLM loops at the RTL level with power feedback (these narrow the claim)

- **VeriOpt** (ICCAD 2025, [2507.14776](https://arxiv.org/abs/2507.14776)): multi-role LLM, PPA-aware prompting, feedback from synthesis reports. Up to 88% power reduction.
- **POET** (USC, March 2026, [2603.19333](https://arxiv.org/abs/2603.19333)): LLM evolutionary search with "power-first" non-dominated ranking.
- **ARES** (KU Leuven, July 2026, [2607.27879](https://arxiv.org/abs/2607.27879)): LLM agent minimizing a PPA figure of merit. It notes that timing-only optimization can raise power.
- **RTLScout** ([2606.06530](https://arxiv.org/html/2606.06530v1)) and **LLM-VeriPPA** (MLCAD 2025): PPA feedback from Yosys/OpenROAD. Not read in full.

### C. Power-aware HLS DSE without LLMs (overlaps the proposal's Baseline C)

- **HL-Pow** (HKUST and Sharad Sinha, ASP-DAC 2020, [2009.00871](https://arxiv.org/abs/2009.00871)): already includes a DSE that trades latency against power.
- **PowerGear** (DATE 2022, [2201.10114](https://arxiv.org/abs/2201.10114)): GNN, 3.60% error against the board. It reports Vivado's own post-implementation power with SAIF activity at 21.82% average error against the board. TCAD 2025 extension ([PDF](https://zhaokang-lab.github.io//papers/2025/2025_TCAD_YanSen.pdf)).
- Also HGBO-DSE, the DAC'22 GNN predictor ([2201.06848](https://arxiv.org/pdf/2201.06848)), HLSDataset ([2302.10977](https://ar5iv.labs.arxiv.org/html/2302.10977)), ATAPP (FPL 2025), and MOTPE over PPA (2023).

**Conclusion:** the gap is real but narrow. No paper found uses power, energy or EDP as feedback in an LLM/agentic **HLS pragma** loop. The general idea of an LLM loop with power feedback is already published at RTL, and power-aware HLS DSE without LLMs dates to 2020.

## 2. Claim verification

| Claim in the proposal | Verdict | Notes |
|---|---|---|
| Vitis HLS 2024 reports per-configuration dynamic and static power at no extra synthesis cost, within 15–20% of post-route | **Not supported** | The C-synthesis summary (UG1399) has no power. `export_design -flow syn/impl` adds timing and resources. Power needs Vivado `report_power`, which is vectorless unless given simulation SAIF, so it costs minutes per point. No source found for 15–20%; PowerGear finds Vivado SAIF power itself 21.8% off the board. The proposal's "no extra cost" and "cosim-based, 2–4 min" also contradict each other. |
| LLM-DSE: 2.55× geomean over AutoDSE | **Partly** | 2.55× is the arithmetic mean against AutoDSE-8h; the geomean is 1.87×. Against AutoDSE-24h it is 1.60×, against HARP-24h 1.16×. Latency and area only: verified. Code: https://github.com/Nozidoali/LLM-DSE |
| A3D: 1.04 W vs. 3.6 W edge GPU | **Verified, with caveats** | Simulator-estimated and scaled to 8 nm. A 0.87 W variant exists. Uses Catapult and Claude Sonnet 4.5. Power is not in the loop. |
| "Are LLMs Any Good for HLS?": 38.67% fewer resources, 64% fewer cycles | **Partly** | The paper's 38.67% is the average reduction in resources and power over 7 of 9 kernels; recomputing gives about 47.9% for power. The paper translates C to Verilog with an LLM; it is not DSE. |
| HL-Pow: 4.67% error (UC Irvine) | **Verified, wrong affiliation** | HKUST plus Sinha, ASP-DAC 2020. |
| Agent Factories: 7.07× at 8 agents | **Partly** | The v2 abstract says 1→10 agents gives 7.07×. v2 Table II has 7.07× at 8 agents and 6.53× at 10. The v1 abstract said 8.27×. No power. |
| Antmicro OpenROAD + SAIF flow, July 2025 | **Verified** | An ASIC flow (Verilator SAIF → OpenROAD `report_power`). It does not validate FPGA/Vitis power. |

## 3. Threats and how to differentiate

- **Intelligent4DSE** is the closest prior work. It has LLM HLS DSE and power labels but does not optimize power, so reviewers may call adding power "one more objective". Cite it and show why it isn't.
- **VeriOpt, POET and ARES** make "first agent to see power" false unless the claim is scoped to **HLS/FPGA pragma DSE**.
- **HL-Pow and PowerGear** already did latency–power HLS DSE. Present Baseline C as a re-implementation.

Ways to differentiate:
1. Show that agents *reason* about power, by ablating power-in-prompt against power-as-scalar against latency-only.
2. Treat the fidelity of the power signal as the research question: vectorless vs. activity-annotated vs. surrogate.
3. Report energy and EDP on LLM-DSE's own setup, whose code is public.
4. Rewrite the motivation. Vitis C synthesis does **not** produce power, and that missing signal *is* the motivation.

## Gate G1 verdict

**Pass, conditionally (partly closed gap).** No agentic HLS pragma DSE uses power as feedback, but RTL-level LLM loops already do (2025–2026) and power-aware HLS DSE without LLMs exists (2020–2025). The thesis must narrow its claim to "first agentic HLS/FPGA pragma DSE with power in the loop", and fix the Vitis-power premise before submission.
