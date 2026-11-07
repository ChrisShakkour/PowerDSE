"""Logic synthesis, timing and power of an HLS-generated Verilog design on ASAP7 (RVT, one corner).

Synthesis is Bambu's own asap7 Yosys script (panda/scripts/synth.tcl) with the settings of its asap7 flow, as in
experaments/hls_synth/logic_synth.py. Timing and power are OpenROAD's OpenSTA, run in `openroad` (the standalone
`sta` of this build has no VCD reader), with the ASAP7 LEF loaded so `link_design` works. There is no placement or
routing: wire loads and the clock tree are not modelled.

Correctness: Bambu's asap7 script maps adders with `extract_fa` + its FA/HA techmap when ADDER_MAP_FILE is set. In
the Yosys build used here (0.38) `extract_fa` produces wrong logic, so that step is disabled (see yosys() below).

Power tiers (pdse.power selects them):
  P0  vectorless: OpenSTA default activity (0.1 toggles per clock on inputs, propagated through the logic).
  P1  activity-annotated: the same netlist, with toggle rates read from an RTL simulation VCD (Bambu --generate-vcd)
      via `read_power_activities -scope`; nets the VCD does not name keep propagated activity.
"""

from __future__ import annotations

import os
import re
import shutil
import subprocess
from pathlib import Path

PANDA = Path.home() / "tools" / "bambu" / "squashfs-root" / "usr" / "share" / "panda"
ASIC_BIN = Path(os.environ.get("ASIC_BIN", Path.home() / "miniforge3" / "envs" / "asic" / "bin"))

LIB_KINDS = ("AO", "INVBUF", "OA", "SEQ", "SIMPLE")
DONT_USE_CELLS = "*x1_ASAP7* *x1p*_ASAP7* *xp*_ASAP7* SDF* ICG* DFFH*"  # panda/asap7/config.mk
FLOW_ENV = {
    "ABC_DRIVER_CELL": "BUFx2_ASAP7_75t_R",
    "ABC_LOAD_IN_FF": "3.898",
    "ABC_AREA": "0",
    "SYNTH_ARGS": "-flatten",
    "TIEHI_CELL_AND_PORT": "TIEHIx1_ASAP7_75t_R H",
    "TIELO_CELL_AND_PORT": "TIELOx1_ASAP7_75t_R L",
    "MIN_BUF_CELL_AND_PORTS": "BUFx2_ASAP7_75t_R A Y",
}
LEFS = (PANDA / "asap7" / "lef" / "asap7_tech_1x_201209.lef", PANDA / "asap7" / "lef" / "asap7sc7p5t_27_R_1x_201211.lef")

STA_TCL = """\
foreach lef {{{lefs}}} {{ read_lef $lef }}
foreach lib {{{libs}}} {{ read_liberty $lib }}
read_verilog {netlist}
link_design {top}
set_cmd_units -time ps -power W
create_clock -name clk -period {period_ps} [get_ports {clock}]
set ins [delete_from_list [all_inputs] [get_ports {clock}]]
set_input_delay 0 -clock clk $ins
set_output_delay 0 -clock clk [all_outputs]
{activity}
puts "PDSE_BEGIN_TIMING"
report_checks -path_delay max -fields {{slew cap input_pins}} -digits 2
report_worst_slack -max -digits 2
report_tns -digits 2
puts "PDSE_BEGIN_POWER"
report_power -digits 6
"""


def libs(corner: str = "TT") -> list[Path]:
    return [PANDA / "asap7" / "lib" / f"asap7sc7p5t_{k}_RVT_{corner}_nldm_201020.lib" for k in LIB_KINDS]


def run(cmd, cwd: Path, env: dict, log: Path, timeout: float | None = None) -> int:
    with open(log, "w") as f:
        f.write(f"$ {' '.join(map(str, cmd))}\n\n")
        f.flush()
        try:
            return subprocess.run(list(map(str, cmd)), cwd=cwd, env=env, stdout=f, stderr=subprocess.STDOUT,
                                  timeout=timeout).returncode
        except subprocess.TimeoutExpired:
            f.write("\nPDSE: timeout\n")
            return -1


def _prepare_libs(objects: Path, corner: str) -> tuple[list[Path], Path]:
    """Bambu's flow steps: mark the dont_use cells in each library, then merge them for ABC and dfflibmap."""
    libdir = objects / "lib"
    libdir.mkdir(parents=True, exist_ok=True)
    marked = []
    for i, src in enumerate(libs(corner)):
        dst = libdir / f"tobemerged{i}.lib"
        subprocess.run(["python3", PANDA / "util" / "markDontUse.py", "-p", DONT_USE_CELLS, "-i", src, "-o", dst],
                       check=True, capture_output=True)
        marked.append(dst)
    merged = libdir / "merged.lib"
    with open(merged, "w") as f:
        subprocess.run(["perl", PANDA / "util" / "mergeLib.pl", "asap7_merged", *marked], check=True, stdout=f)
    return marked, merged


def yosys(verilog: Path, top: str, mhz: float, work: Path, corner: str = "TT", timeout: float = 3600) -> dict:
    """Gate-level netlist in work/results/1_1_yosys.v; returns cells, flip-flops and cell area."""
    if work.exists():
        shutil.rmtree(work)
    objects, reports, results = work / "objects", work / "reports", work / "results"
    for d in (objects, reports, results):
        d.mkdir(parents=True)
    marked, merged = _prepare_libs(objects, corner)
    yo = PANDA / "asap7" / "yoSys"
    env = os.environ | FLOW_ENV | {
        "PATH": f"{os.environ['PATH']}:{ASIC_BIN}",
        "SCRIPTS_DIR": str(PANDA / "scripts"),
        "DESIGN_NAME": top,
        "VERILOG_FILES": str(verilog),
        "DONT_USE_LIBS": " ".join(map(str, marked)),
        "DONT_USE_SC_LIB": str(merged),
        # No ADDER_MAP_FILE: with it, synth.tcl runs `extract_fa`, which in Yosys 0.38 produces functionally wrong
        # adders (a SAT miter of a 32-bit a+b fails; the gate-level co-simulation of every design fails). Without it,
        # adders go through Yosys' generic techmap and ABC, which is proven equivalent. See reports/flow_bug.md.
        "LATCH_MAP_FILE": str(yo / "cells_latch.v"),
        "CLKGATE_MAP_FILE": str(yo / "cells_clkgate.v"),
        "ABC_CLOCK_PERIOD_IN_PS": f"{1e6 / mhz:g}",
        "OBJECTS_DIR": str(objects), "REPORTS_DIR": str(reports), "RESULTS_DIR": str(results),
    }
    rc = run([ASIC_BIN / "yosys", "-c", PANDA / "scripts" / "synth.tcl"], work, env, work / "yosys.log", timeout)
    netlist = results / "1_1_yosys.v"
    if rc != 0 or not netlist.exists():
        return {"synth_status": "yosys_failed"}
    log = (work / "yosys.log").read_text(errors="replace")
    stat = log[log.rfind("Printing statistics"):]
    out = {"synth_status": "pass", "netlist": str(netlist)}
    if m := re.search(r"Chip area for (?:top )?module .*?:\s*([\d.]+)", stat):
        out["cell_area_um2"] = float(m[1])
    if m := re.search(r"Number of cells:\s*(\d+)", stat):
        out["cells"] = int(m[1])
    out["flip_flops"] = sum(int(n) for n in re.findall(r"^\s+DFF\w*_ASAP7\w*\s+(\d+)", stat, re.MULTILINE))
    return out


def sta(netlist: Path, top: str, mhz: float, work: Path, *, clock: str = "clock", corner: str = "TT",
        vcd: Path | None = None, vcd_scope: str | None = None, tag: str = "p0", timeout: float = 3600) -> dict:
    """Timing and power of a netlist. With `vcd`, toggle rates come from the VCD (scope = path to the design)."""
    period_ps = 1e6 / mhz
    activity = ""
    if vcd is not None:
        scope = f"-scope {vcd_scope} " if vcd_scope else ""
        activity = f"read_power_activities {scope}-vcd {vcd}"
    script = work / f"sta_{tag}.tcl"
    script.write_text(STA_TCL.format(lefs=" ".join(map(str, LEFS)), libs=" ".join(map(str, libs(corner))),
                                     netlist=netlist, top=top, period_ps=f"{period_ps:g}", clock=clock,
                                     activity=activity))
    log = work / f"sta_{tag}.log"
    env = os.environ | {"PATH": f"{os.environ['PATH']}:{ASIC_BIN}"}
    rc = run([ASIC_BIN / "openroad", "-no_init", "-no_splash", "-exit", script], work, env, log, timeout)
    text = log.read_text(errors="replace")
    out = {"sta_status": "pass" if rc == 0 and "PDSE_BEGIN_POWER" in text else "sta_failed"}
    out |= parse_sta(text, period_ps)
    if vcd is not None:
        if m := re.search(r"Annotated (\d+) pin activities", text):  # OpenROAD's read_power_activities summary
            out["annotated_pins"] = int(m[1])
    return out


def parse_sta(text: str, period_ps: float) -> dict:
    out = {}
    if m := re.search(r"^worst slack\s+(\S+)", text, re.MULTILINE):
        slack = float(m[1])
        out["worst_slack_ps"] = round(slack, 2)
        out["critical_path_ps"] = round(period_ps - slack, 2)
        out["fmax_mhz"] = round(1e6 / (period_ps - slack), 1)
    power = text[text.find("PDSE_BEGIN_POWER"):]
    # report_power rows: Group  Internal  Switching  Leakage  Total  (W)
    for group, key in (("Sequential", "seq"), ("Combinational", "comb"), ("Clock", "clk"), ("Total", "total")):
        if m := re.search(rf"^{group}\s+([\d.eE+-]+)\s+([\d.eE+-]+)\s+([\d.eE+-]+)\s+([\d.eE+-]+)", power,
                          re.MULTILINE):
            internal, switching, leakage, total = map(float, m.groups())
            out[f"power_{key}_w"] = total
            if key == "total":
                out |= {"power_internal_w": internal, "power_switching_w": switching, "power_leakage_w": leakage,
                        "power_dynamic_w": internal + switching}
    return out
