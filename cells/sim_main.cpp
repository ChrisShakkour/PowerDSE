// Verilator main for activity-annotated power (replaces Bambu's HLS_output/beh_sim/sim_main.cpp when rebuilding).
// Differences from Bambu's: simulation time still advances 1 unit per half clock (Bambu's testbench counts cycles from
// $time), but VCD timestamps are written in ps at the design's real clock period (Bambu's would read as a 500 GHz
// clock), and only a window of clock cycles is dumped, so the VCD is a steady-state stretch of manageable size.
//   -DPDSE_HALF_PS=<half period in ps>  -DPDSE_DUMP_FROM=<first cycle>  -DPDSE_DUMP_CYCLES=<cycles to dump>
#include <memory>

#include <verilated.h>
#include <verilated_vcd_c.h>
#define _dtos(str) #str
#define VCD_OUT_FILENAME(dir, stem) _dtos(dir) "/" stem

#include "Vbambu_testbench.h"

#ifndef PDSE_HALF_PS
#define PDSE_HALF_PS 1000
#endif
#ifndef PDSE_DUMP_FROM
#define PDSE_DUMP_FROM 200
#endif
#ifndef PDSE_DUMP_CYCLES
#define PDSE_DUMP_CYCLES 50000
#endif

vluint64_t main_time = 0;
double sc_time_stamp() { return main_time; }

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    const std::unique_ptr<Vbambu_testbench> top{new Vbambu_testbench{"clocked_bambu_testbench"}};
    Verilated::traceEverOn(true);
    const std::unique_ptr<VerilatedVcdC> tfp{new VerilatedVcdC};
    top->trace(tfp.get(), 99);
    tfp->set_time_unit("p");
    tfp->set_time_resolution("p");
    const vluint64_t from = (vluint64_t)PDSE_DUMP_FROM * 2;  // in half clocks
    const vluint64_t to = from + (vluint64_t)PDSE_DUMP_CYCLES * 2;
    bool open = false;
    top->clock = 1;
    while (!Verilated::gotFinish()) {
        top->clock = !top->clock;
        top->eval();
        if (main_time >= from && main_time <= to) {
            if (!open) {
                tfp->open(VCD_OUT_FILENAME(VCD_OUT_DIR, "test.vcd"));
                open = true;
            }
            tfp->dump(main_time * PDSE_HALF_PS);
        }
        main_time += 1;
    }
    if (open) tfp->close();
    top->final();
    return 0;
}
