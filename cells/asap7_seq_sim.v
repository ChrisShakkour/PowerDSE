// Simulation models (for the Verilator simulator) of the ASAP7 flip-flops the Bambu flow can produce (the official SEQ models use
// UDP tables, which Verilator does not support). Functionally equivalent, no timing.
`timescale 1ps/1ps
module DFFLQNx1_ASAP7_75t_R (QN, D, CLK);
  output reg QN = 1'b1;  // stored value 0 at time 0, like the RTL under --x-initial fast
  input D, CLK;
  always @(negedge CLK) QN <= ~D;
endmodule
module DFFLQNx2_ASAP7_75t_R (QN, D, CLK);
  output reg QN = 1'b1;  // stored value 0 at time 0, like the RTL under --x-initial fast
  input D, CLK;
  always @(negedge CLK) QN <= ~D;
endmodule
module DFFLQNx3_ASAP7_75t_R (QN, D, CLK);
  output reg QN = 1'b1;  // stored value 0 at time 0, like the RTL under --x-initial fast
  input D, CLK;
  always @(negedge CLK) QN <= ~D;
endmodule
module DFFLQx4_ASAP7_75t_R (Q, D, CLK);
  output reg Q = 1'b0;
  input D, CLK;
  always @(negedge CLK) Q <= D;
endmodule
module DFFHQNx1_ASAP7_75t_R (QN, D, CLK);
  output reg QN = 1'b1;  // stored value 0 at time 0, like the RTL under --x-initial fast
  input D, CLK;
  always @(posedge CLK) QN <= ~D;
endmodule
module DFFHQNx2_ASAP7_75t_R (QN, D, CLK);
  output reg QN = 1'b1;  // stored value 0 at time 0, like the RTL under --x-initial fast
  input D, CLK;
  always @(posedge CLK) QN <= ~D;
endmodule
module DFFHQNx3_ASAP7_75t_R (QN, D, CLK);
  output reg QN = 1'b1;  // stored value 0 at time 0, like the RTL under --x-initial fast
  input D, CLK;
  always @(posedge CLK) QN <= ~D;
endmodule
module DFFHQx4_ASAP7_75t_R (Q, D, CLK);
  output reg Q = 1'b0;
  input D, CLK;
  always @(posedge CLK) Q <= D;
endmodule

// Simulation-only stand-ins: pdse/gatesim.py rewires falling-edge flops whose CLK is an inverted copy of the clock
// straight to the clock and retypes them to these (same function, triggered on the clock's rising edge). With the
// zero-delay inverter in the clock path the testbench's inputs would otherwise change before the flops sample them.
module DFFLQNx1_ASAP7_75t_R_POSCLK (QN, D, CLK);
  output reg QN = 1'b1;
  input D, CLK;
  always @(posedge CLK) QN <= ~D;
endmodule
module DFFLQNx2_ASAP7_75t_R_POSCLK (QN, D, CLK);
  output reg QN = 1'b1;
  input D, CLK;
  always @(posedge CLK) QN <= ~D;
endmodule
module DFFLQNx3_ASAP7_75t_R_POSCLK (QN, D, CLK);
  output reg QN = 1'b1;
  input D, CLK;
  always @(posedge CLK) QN <= ~D;
endmodule
