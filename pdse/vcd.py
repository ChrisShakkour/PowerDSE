"""Make an RTL-simulation VCD match a flattened Yosys netlist, for activity-annotated power.

Yosys flattens the design and keeps the surviving hierarchical names as single escaped identifiers joined with dots
(`\\__Z4gemmPiS_S__i0.Datapath_i.reg_5.out1[3] `), while the RTL VCD nests them in scopes
(top > __Z4gemmPiS_S__i0 > Datapath_i > reg_5 > out1). `flatten_scopes` rewrites only the VCD header: every variable
below `design_scope` is declared directly in that scope under its dotted path, so OpenROAD's
`read_power_activities -scope <design_scope path>` finds it as a net of the flat netlist. The value-change body
(identifier codes) is copied unchanged.
"""

from __future__ import annotations

import re
from pathlib import Path

_VAR = re.compile(r"^(\s*\$var\s+\S+\s+\d+\s+\S+\s+)(\S+)(.*\$end\s*)$")


def flatten_scopes(src: Path, dst: Path, design_scope: list[str]) -> dict:
    """design_scope: the scope names from the VCD root down to the design's top module instance."""
    stack: list[str] = []
    out_lines: list[str] = []
    depth_of_design = len(design_scope)
    flattened = kept = 0
    body_offset = None
    with open(src, "rb") as f:
        while raw := f.readline():
            line = raw.decode(errors="replace")
            s = line.strip()
            inside = len(stack) > depth_of_design and stack[:depth_of_design] == design_scope
            if s.startswith("$scope"):
                stack.append(s.split()[2])
                if not (len(stack) > depth_of_design and stack[:depth_of_design] == design_scope):
                    out_lines.append(line)
                continue
            if s.startswith("$upscope"):
                if not inside:
                    out_lines.append(line)
                stack.pop()
                continue
            if s.startswith("$var real"):  # OpenSTA's VCD reader rejects real variables (testbench parameters)
                continue
            if s.startswith("$var") and inside:
                m = _VAR.match(line.rstrip("\n"))
                if m:
                    out_lines.append(f"{m[1]}{'.'.join(stack[depth_of_design:] + [m[2]])}{m[3]}\n")
                    flattened += 1
                    continue
            if s.startswith("$var"):
                kept += 1
            out_lines.append(line)
            if s.startswith("$enddefinitions"):
                body_offset = f.tell()
                break
    if body_offset is None:
        raise ValueError(f"{src}: no $enddefinitions")
    with open(dst, "w") as o:
        o.writelines(out_lines)
    with open(src, "rb") as f, open(dst, "ab") as o:
        f.seek(body_offset)
        for raw in f:  # drop real-valued changes ("r<value> <id>"), whose variables were dropped above
            if not raw.startswith(b"r"):
                o.write(raw)
    return {"vcd_vars_flattened": flattened, "vcd_vars_other": kept}


def drop_reals(src: Path, dst: Path) -> None:
    """Copy a VCD without real-valued variables (OpenSTA's reader fails on them: `stoll`, or "unknown variable")."""
    with open(src, "rb") as f, open(dst, "wb") as o:
        header = True
        for raw in f:
            if header:
                if raw.lstrip().startswith(b"$var real"):
                    continue
                if raw.lstrip().startswith(b"$enddefinitions"):
                    header = False
            elif raw.startswith(b"r"):
                continue
            o.write(raw)
