"""The pilot design space (gemm_int32 on Bambu, ASAP7) and the evaluation of one design point.

A design point is a choice of five knobs, the open-source stand-ins for the Vitis pragmas in the proposal:

    mhz      clock target                          (Vitis: clock)
    unroll   inner-loop unroll factor, as a clang loop pragma in the source   (UNROLL factor)
    mem      memory channels of the array interface: 11 = one port, nn2 / nn4 = 2 / 4 parallel ports
                                                   (ARRAY_PARTITION: more parallel accesses per cycle)
    popt     Bambu --power-optimization            (no Vitis analogue; Bambu's own power option)
    frac     Bambu --DSP-fracturing=16 (split multipliers into <=16-bit pieces) or off

evaluate() runs, for one point: Bambu HLS + Verilator co-simulation (correctness, cycles), Yosys logic synthesis at
the same clock, OpenSTA timing, and power three ways: P0 vectorless; P1 with toggle activity from an RTL co-simulation
(annotating the nets whose names survive synthesis); P1g with activity from a gate-level co-simulation of the netlist
in the same testbench (every net; it also proves the netlist correct). Both co-simulations dump a steady-state window
at the real clock period (cells/sim_main.cpp). It returns one flat row; the VCDs are deleted afterwards.
"""

from __future__ import annotations

import itertools
import os
import re
import shutil
import subprocess
import time
from dataclasses import asdict, dataclass
from pathlib import Path

from . import gatesim, synth, vcd

ROOT = Path(__file__).resolve().parents[1]
BAMBU = os.environ.get("BAMBU", str(Path.home() / "tools" / "bambu" / "bambu-extracted"))
VERILATOR_DIR = os.environ.get("VERILATOR_DIR", str(Path.home() / "miniforge3" / "envs" / "eda" / "bin"))

KNOBS = {
    "mhz": (250, 500, 750, 1000),
    "unroll": (1, 2, 4, 8),
    "mem": ("11", "nn2", "nn4"),
    "popt": (0, 1),
    "frac": (0, 16),
}
MEM_ARGS = {
    "11": ["--channels-type=MEM_ACC_11"],
    "nn2": ["--channels-type=MEM_ACC_NN", "--channels-number=2"],
    "nn4": ["--channels-type=MEM_ACC_NN", "--channels-number=4"],
}

# Bambu log metrics: last value of each (the kernel has one function).
METRICS = {
    "cycles": r"Total cycles\s*:\s*(\d+)",
    "est_max_mhz": r"Estimated max frequency \(MHz\):\s*([\d.eE+-]+)",
    "bambu_area": r"Total estimated area:\s*([\d.]+)",
    "bambu_flip_flops": r"Total number of flip-flops in function \S+:\s*(\d+)",
}


@dataclass(frozen=True)
class Point:
    mhz: int
    unroll: int
    mem: str
    popt: int
    frac: int

    @property
    def id(self) -> str:
        return f"{self.mhz}MHz_u{self.unroll}_m{self.mem}_po{self.popt}_df{self.frac}"

    @classmethod
    def from_id(cls, s: str) -> "Point":
        m = re.fullmatch(r"(\d+)MHz_u(\d+)_m(\w+?)_po(\d)_df(\d+)", s)
        if not m:
            raise ValueError(f"not a design point id: {s}")
        return cls(int(m[1]), int(m[2]), m[3], int(m[4]), int(m[5]))


def all_points() -> list[Point]:
    return [Point(*v) for v in itertools.product(*KNOBS.values())]


@dataclass(frozen=True)
class Kernel:
    name: str
    dir: Path
    template: str  # kernel source with @UNROLL_PRAGMA@
    header: str
    tb: str
    top: str  # C function name
    rtl_top: str  # Verilog module name Bambu writes
    tb_param_size: str
    work_units: int  # multiply-accumulates per call, for throughput and energy per operation


GEMM_INT32 = Kernel("gemm_int32", ROOT / "kernels" / "gemm_int32", "gemm.cpp.in", "gemm.h", "gemm_tb.cpp", "gemm",
                    "_Z4gemmPiS_S_", "m1:16384,m2:16384,prod:16384", 64 * 64 * 64)
VCD_DESIGN_SCOPE = ["clocked_bambu_testbench", "bambu_testbench", "system", "DUT", "top"]


def unroll_pragma(u: int) -> str:
    return "#pragma clang loop unroll(disable)" if u == 1 else f"#pragma clang loop unroll_count({u})"


def bambu(k: Kernel, p: Point, work: Path, timeout: float = 3600) -> dict:
    for f in (k.header, k.tb):
        shutil.copy(k.dir / f, work / f)
    src = (k.dir / k.template).read_text().replace("@UNROLL_PRAGMA@", unroll_pragma(p.unroll))
    kernel_file = k.template.removesuffix(".in")
    (work / kernel_file).write_text(src)
    cmd = [BAMBU, kernel_file, f"--top-fname={k.top}", "-I.", "--compiler=I386_CLANG16", "--std=c++14", "-O2",
           "--device-name=asap7-TC", f"--clock-period={1000 / p.mhz:.4f}", "--generate-interface=MINIMAL",
           f"--generate-tb={k.tb}", "--simulate", "--simulator=VERILATOR", f"--tb-param-size={k.tb_param_size}",
           "--reset-type=sync", "--disable-reg-init-value", *MEM_ARGS[p.mem]]
    if p.popt:
        cmd.append("--power-optimization")
    if p.frac:
        cmd.append(f"--DSP-fracturing={p.frac}")
    env = os.environ | {"PATH": f"{VERILATOR_DIR}:{os.environ['PATH']}"}
    start = time.monotonic()
    try:
        r = subprocess.run(cmd, cwd=work, env=env, capture_output=True, text=True, errors="replace", timeout=timeout)
        log, rc = r.stdout + r.stderr, r.returncode
    except subprocess.TimeoutExpired as e:
        log, rc = (e.stdout if isinstance(e.stdout, str) else "") or "", None
    (work / "bambu.log").write_text(f"$ {' '.join(cmd)}\n\n{log}")
    row = {"hls_status": "timeout" if rc is None else ("pass" if rc == 0 else "fail"),
           "hls_seconds": round(time.monotonic() - start, 1)}
    for name, pat in METRICS.items():
        found = re.findall(pat, log)
        row[name] = float(found[-1]) if found else None
    if row["hls_status"] == "fail":
        errs = re.findall(r"^error -> (.*)$", log, re.MULTILINE)
        row["error"] = (errs[-1] if errs else f"exit {rc}")[:200]
    return row


def evaluate(k: Kernel, p: Point, out_root: Path, *, keep_vcd: bool = False) -> dict:
    work = out_root / k.name / p.id
    if work.exists():
        shutil.rmtree(work)
    work.mkdir(parents=True)
    row = {"kernel": k.name, "id": p.id, **asdict(p)}
    row |= bambu(k, p, work)
    if row["hls_status"] != "pass" or not row.get("cycles"):
        row["status"] = "hls_" + row["hls_status"]
        return row
    rtl = work / f"{k.template.removesuffix('.cpp.in')}.v"
    rtl = rtl if rtl.exists() else next(work.glob("*.v"))
    period_ps = 1e6 / p.mhz
    scope = "/".join(VCD_DESIGN_SCOPE)

    start = time.monotonic()
    syn = synth.yosys(rtl, k.rtl_top, p.mhz, work / "synth")
    row |= {key: v for key, v in syn.items() if key != "netlist"}
    if syn["synth_status"] != "pass":
        row["status"] = "synth_failed"
        return row
    netlist = Path(syn["netlist"])
    p0 = synth.sta(netlist, k.rtl_top, p.mhz, work / "synth", tag="p0")
    row |= {"p0_" + key if key.startswith("power") else key: v for key, v in p0.items()}
    row["synth_seconds"] = round(time.monotonic() - start, 1)

    # P1: RTL co-simulation activity on the nets whose names survive synthesis
    rs = gatesim.run(work, rtl, k.rtl_top, None, period_ps=period_ps, tag="rtlsim")
    row |= {key: v for key, v in rs.items() if not key.endswith("_vcd")}
    if rs.get("rtlsim_status") == "pass":
        flat = work / "rtlsim" / "flat.vcd"
        row |= vcd.flatten_scopes(Path(rs["rtlsim_vcd"]), flat, VCD_DESIGN_SCOPE)
        Path(rs["rtlsim_vcd"]).unlink(missing_ok=True)
        p1 = synth.sta(netlist, k.rtl_top, p.mhz, work / "synth", vcd=flat, vcd_scope=scope, tag="p1")
        row |= {"p1_" + key: v for key, v in p1.items() if key.startswith("power") or key == "annotated_pins"}
        if not keep_vcd:
            flat.unlink(missing_ok=True)

    # P1g: gate-level co-simulation of the netlist in Bambu's testbench (also proves the netlist is correct)
    gl = gatesim.run(work, rtl, k.rtl_top, netlist, period_ps=period_ps, tag="glsim")
    row |= {key: v for key, v in gl.items() if not key.endswith("_vcd")}
    if gl.get("glsim_status") == "pass":
        p1g = synth.sta(netlist, k.rtl_top, p.mhz, work / "synth", vcd=Path(gl["glsim_vcd"]), vcd_scope=scope,
                        tag="p1g")
        row |= {"p1g_" + key: v for key, v in p1g.items() if key.startswith("power") or key == "annotated_pins"}
        if not keep_vcd:
            Path(gl["glsim_vcd"]).unlink(missing_ok=True)

    if gl.get("glsim_status") == "fail":
        row["status"] = "netlist_mismatch"
    elif p0.get("sta_status") != "pass" or row.get("p1g_power_total_w") is None:
        row["status"] = "power_failed"
    else:
        row["status"] = "pass"
    return derived(row, k)


def derived(row: dict, k: Kernel) -> dict:
    """Latency in time, throughput, and energy per call from cycles, clock and power (per tier)."""
    cycles, mhz = row.get("cycles"), row.get("mhz")
    if cycles:
        row["latency_us"] = round(cycles / mhz, 3)
        row["macs_per_cycle"] = round(k.work_units / cycles, 4)
        if row.get("fmax_mhz"):
            row["latency_us_at_fmax"] = round(cycles / min(mhz, row["fmax_mhz"]), 3)
        for tier in ("p0", "p1", "p1g"):
            if (pw := row.get(f"{tier}_power_total_w")) is not None:
                row[f"{tier}_energy_uj"] = round(pw * cycles / mhz, 6)  # W × µs = µJ
    return row
