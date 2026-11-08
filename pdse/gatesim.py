"""Gate-level co-simulation of a synthesized netlist inside Bambu's own testbench (for activity-annotated power).

After a Bambu run with --simulate --simulator=VERILATOR, its work directory holds the C testbench (linked with the
MDPI driver), the Verilog testbench, and simulate_<top>.sh. This module rebuilds the Verilator model with the RTL
design replaced by the gate-level netlist plus cell models, then runs the C testbench exactly as Bambu's script does
(it launches the simulator itself through M_IPC_SIM_CMD). The result is:
  - a functional check of the netlist (the testbench's own result check, and its exit code), and
  - a VCD in which every net of the netlist toggles as in silicon (zero-delay), for `read_power_activities`.

Cell models: cells/asap7_lib_comb.v (written by Yosys from the ASAP7 liberty functions, so the simulation uses the same
logic functions as STA) and cells/asap7_seq_sim.v (flip-flops; the liberty/ORFS models use UDP tables Verilator does
not support). Bambu's asap7 flow maps every register to a falling-edge flop on an inverted clock; with a zero-delay
inverter the flops would sample after the testbench has already changed its inputs, so for simulation only those
flops are rewired to the clock and retyped to equivalent rising-edge models (*_POSCLK). The inverter stays, so its
output net still toggles; the netlist used for STA is not modified.
"""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import time
from pathlib import Path

from .vcd import drop_reals

ROOT = Path(__file__).resolve().parents[1]
CELLS = [ROOT / "cells" / "asap7_lib_comb.v", ROOT / "cells" / "asap7_seq_sim.v"]
VERILATOR_DIR = os.environ.get("VERILATOR_DIR", str(Path.home() / "miniforge3" / "envs" / "eda" / "bin"))


def sim_netlist(netlist: Path, dst: Path) -> int:
    """Copy of the netlist with inverted-clock flops rewired to the clock; returns how many were rewired."""
    t = netlist.read_text()
    inv = set(re.findall(r"(?:INV|CKINV)\w*_ASAP7_75t_R\s+\S+\s*\(\s*\.A\(clock\),\s*\.Y\((\S+?)\)\s*\)", t))
    n = 0

    def fix(m):
        nonlocal n
        c = re.search(r"\.CLK\((\S+?)\)", m[2])
        if c and c[1] in inv:
            n += 1
            return f"{m[1]}_POSCLK{m[2].replace(c[0], '.CLK(clock)')}"
        return m[0]

    dst.write_text(re.sub(r"(DFFLQNx\d_ASAP7_75t_R)(\s+\S+\s*\([^;]*?\);)", fix, t))
    return n


def run(work: Path, rtl_verilog: Path, rtl_top: str, netlist: Path | None, *, period_ps: float, tag: str,
        dump_from: int = 200, dump_cycles: int = 50_000, timeout: float = 7200) -> dict:
    """Co-simulation in Bambu work dir `work` with pdse's sim_main (real clock period, a window of `dump_cycles`
    cycles dumped from cycle `dump_from`). netlist=None simulates the RTL (for P1); otherwise the gate-level netlist
    replaces the RTL design module (for P1g). The VCD is left at <work>/<tag>/activity.vcd."""
    d = work / tag
    if d.exists():
        shutil.rmtree(d)
    d.mkdir()
    sources = [rtl_verilog]
    rewired = 0
    if netlist is not None:
        rewired = sim_netlist(netlist, d / "netlist_sim.v")
        wrapper = d / "rtl_wrapper.v"  # the RTL with its design module renamed away; keeps the wrapper modules
        wrapper.write_text(re.sub(rf"^module {re.escape(rtl_top)}\(", f"module {rtl_top}__rtl_replaced(",
                                  rtl_verilog.read_text(), count=1, flags=re.M))
        sources = [wrapper, d / "netlist_sim.v", *CELLS]
    shutil.copy(ROOT / "cells" / "sim_main.cpp", d / "sim_main.cpp")
    script = next(work.glob("simulate_*.sh")).read_text()
    vline = next(line for line in script.splitlines() if line.startswith("verilator "))
    vline = vline.replace(f" {rtl_verilog.name} ", " " + " ".join(map(str, sources)) + " ")
    vline = vline.replace("HLS_output/beh_sim/sim_main.cpp", str(d / "sim_main.cpp"))
    obj = f"{d}/obj"
    vline = vline.replace("--Mdir ${obj_dir}", f"--Mdir {obj}").replace("${BEH_DIR}", "HLS_output/beh_sim")
    vline = vline.replace("verilator --cc", "verilator -Wno-style --cc")
    if " --trace " not in vline:  # Bambu adds tracing only with --generate-vcd
        vline = vline.replace(" --cc ", " --trace --trace-underscore --cc ", 1)
    half = max(1, round(period_ps / 2))
    defs = f"-DPDSE_HALF_PS={half} -DPDSE_DUMP_FROM={dump_from} -DPDSE_DUMP_CYCLES={dump_cycles}"
    sh = f"""set -e
cd {work}
export PATH={VERILATOR_DIR}:$PATH
{vline} > {d}/verilate.log 2>&1
ln -sfn {work}/HLS_output {obj}/HLS_output
make -C {obj} -j 4 OPT="-fstrict-aliasing -DVCD_OUT_DIR={d} {defs}" -f Vbambu_testbench.mk Vbambu_testbench > {d}/make.log 2>&1
export M_IPC_SIM_CMD="{obj}/Vbambu_testbench > {d}/verilator.log 2>&1; exit \\$?;"
set +e
HLS_output/simulation/testbench > {d}/testbench.log 2>&1
echo "PDSE_TB_RC=$?"
"""
    (d / "run.sh").write_text(sh)
    start = time.monotonic()
    try:
        p = subprocess.run(["bash", str(d / "run.sh")], capture_output=True, text=True, timeout=timeout)
        out = p.stdout + p.stderr
    except subprocess.TimeoutExpired:
        return {f"{tag}_status": "timeout"}
    (d / "run.log").write_text(out)
    shutil.rmtree(obj, ignore_errors=True)
    m = re.search(r"PDSE_TB_RC=(\d+)", out)
    vcd = d / "test.vcd"
    row = {f"{tag}_seconds": round(time.monotonic() - start, 1)}
    if netlist is not None:
        row[f"{tag}_rewired_flops"] = rewired
    if not m:
        return row | {f"{tag}_status": "build_failed"}
    ok = int(m[1]) == 0 and vcd.exists()
    if ok:
        drop_reals(vcd, d / "activity.vcd")
        vcd.unlink()
    return row | {f"{tag}_status": "pass" if ok else "fail", f"{tag}_vcd": str(d / "activity.vcd")}
