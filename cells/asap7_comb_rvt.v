`timescale 1ps/1ps
// ---- AO (from ORFS asap7 stdcell models; UDPs and specify blocks removed)
// BSD 3-Clause License
// 
// Copyright 2020 Lawrence T. Clark, Vinay Vashishtha, or Arizona State
// University
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// Verilog for library /home/ltclark/ASAP7/LIB2/Liberate_2/Verilog/asap7sc7p5t_AO_RVT_TT_201020 created by Liberate 18.1.0.293 on Sat Nov 28 03:36:02 MST 2020 for SDF version 2.1

// type:  


module A2O1A1Ixp33_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0, C__bar);

	// Timing

endmodule


// type:  


module A2O1A1O1Ixp25_ASAP7_75t_R (Y, A1, A2, B, C, D);
	output Y;
	input A1, A2, B, C, D;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, D__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2;

	not (D__bar, D);
	not (C__bar, C);
	and (int_fwire_0, C__bar, D__bar);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar, D__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar, D__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO211x2_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2);
	or (Y, int_fwire_0, B, C);

	// Timing

endmodule


// type:  


module AO21x1_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2);
	or (Y, int_fwire_0, B);

	// Timing

endmodule


// type:  


module AO21x2_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2);
	or (Y, int_fwire_0, B);

	// Timing

endmodule


// type:  


module AO221x1_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing

endmodule


// type:  


module AO221x2_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing

endmodule


// type:  


module AO222x2_ASAP7_75t_R (Y, A1, A2, B1, B2, C1, C2);
	output Y;
	input A1, A2, B1, B2, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2);
	and (int_fwire_2, A1, A2);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO22x1_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO22x2_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO31x2_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2, A3);
	or (Y, int_fwire_0, B);

	// Timing

endmodule


// type:  


module AO322x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO32x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2);
	output Y;
	input A1, A2, A3, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO32x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2);
	output Y;
	input A1, A2, A3, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO331x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C);
	output Y;
	input A1, A2, A3, B1, B2, B3, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2, B3);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing

endmodule


// type:  


module AO331x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C);
	output Y;
	input A1, A2, A3, B1, B2, B3, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2, B3);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing

endmodule


// type:  


module AO332x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO332x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO333x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2, C3);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO333x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2, C3);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AO33x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3);
	output Y;
	input A1, A2, A3, B1, B2, B3;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2, B3);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI211x1_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar, C__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI211xp5_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar, C__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI21x1_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0, int_fwire_1;

	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI21xp33_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0, int_fwire_1;

	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI21xp5_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0, int_fwire_1;

	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI221x1_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;

	not (C__bar, C);
	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar, C__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar, C__bar);
	and (int_fwire_3, A1__bar, B1__bar, C__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI221xp5_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;

	not (C__bar, C);
	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar, C__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar, C__bar);
	and (int_fwire_3, A1__bar, B1__bar, C__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI222xp33_ASAP7_75t_R (Y, A1, A2, B1, B2, C1, C2);
	output Y;
	input A1, A2, B1, B2, C1, C2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C1__bar, C2__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7;

	not (C2__bar, C2);
	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_1, A2__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A2__bar, B1__bar, C2__bar);
	and (int_fwire_3, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_4, A1__bar, B2__bar, C2__bar);
	and (int_fwire_5, A1__bar, B2__bar, C1__bar);
	and (int_fwire_6, A1__bar, B1__bar, C2__bar);
	and (int_fwire_7, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI22x1_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3;

	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar);
	and (int_fwire_3, A1__bar, B1__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI22xp33_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3;

	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar);
	and (int_fwire_3, A1__bar, B1__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI22xp5_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3;

	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar);
	and (int_fwire_3, A1__bar, B1__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI311xp33_ASAP7_75t_R (Y, A1, A2, A3, B, C);
	output Y;
	input A1, A2, A3, B, C;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, C__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2;

	not (C__bar, C);
	not (B__bar, B);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B__bar, C__bar);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar, C__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI31xp33_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2;

	not (B__bar, B);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B__bar);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI31xp67_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2;

	not (B__bar, B);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B__bar);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI321xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C);
	output Y;
	input A1, A2, A3, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, C__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;

	not (C__bar, C);
	not (B2__bar, B2);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B2__bar, C__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A3__bar, B1__bar, C__bar);
	not (A2__bar, A2);
	and (int_fwire_2, A2__bar, B2__bar, C__bar);
	and (int_fwire_3, A2__bar, B1__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_4, A1__bar, B2__bar, C__bar);
	and (int_fwire_5, A1__bar, B1__bar, C__bar);
	or (Y, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI322xp5_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, C1, C2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, C1__bar;
	wire C2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3, int_fwire_4;
	wire int_fwire_5, int_fwire_6, int_fwire_7;
	wire int_fwire_8, int_fwire_9, int_fwire_10;
	wire int_fwire_11;

	not (C2__bar, C2);
	not (B2__bar, B2);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B2__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_1, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A3__bar, B1__bar, C2__bar);
	and (int_fwire_3, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_4, A2__bar, B2__bar, C2__bar);
	and (int_fwire_5, A2__bar, B2__bar, C1__bar);
	and (int_fwire_6, A2__bar, B1__bar, C2__bar);
	and (int_fwire_7, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_8, A1__bar, B2__bar, C2__bar);
	and (int_fwire_9, A1__bar, B2__bar, C1__bar);
	and (int_fwire_10, A1__bar, B1__bar, C2__bar);
	and (int_fwire_11, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI32xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2);
	output Y;
	input A1, A2, A3, B1, B2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;
	wire int_fwire_4, int_fwire_5;

	not (B2__bar, B2);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A3__bar, B1__bar);
	not (A2__bar, A2);
	and (int_fwire_2, A2__bar, B2__bar);
	and (int_fwire_3, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_4, A1__bar, B2__bar);
	and (int_fwire_5, A1__bar, B1__bar);
	or (Y, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI331xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3, int_fwire_4;
	wire int_fwire_5, int_fwire_6, int_fwire_7;
	wire int_fwire_8;

	not (C1__bar, C1);
	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar, C1__bar);
	not (B2__bar, B2);
	and (int_fwire_1, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_3, A2__bar, B3__bar, C1__bar);
	and (int_fwire_4, A2__bar, B2__bar, C1__bar);
	and (int_fwire_5, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_6, A1__bar, B3__bar, C1__bar);
	and (int_fwire_7, A1__bar, B2__bar, C1__bar);
	and (int_fwire_8, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI332xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, C2__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;
	wire int_fwire_4, int_fwire_5, int_fwire_6;
	wire int_fwire_7, int_fwire_8, int_fwire_9;
	wire int_fwire_10, int_fwire_11, int_fwire_12;
	wire int_fwire_13, int_fwire_14, int_fwire_15;
	wire int_fwire_16, int_fwire_17;

	not (C2__bar, C2);
	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_1, A3__bar, B3__bar, C1__bar);
	not (B2__bar, B2);
	and (int_fwire_2, A3__bar, B2__bar, C2__bar);
	and (int_fwire_3, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_4, A3__bar, B1__bar, C2__bar);
	and (int_fwire_5, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_6, A2__bar, B3__bar, C2__bar);
	and (int_fwire_7, A2__bar, B3__bar, C1__bar);
	and (int_fwire_8, A2__bar, B2__bar, C2__bar);
	and (int_fwire_9, A2__bar, B2__bar, C1__bar);
	and (int_fwire_10, A2__bar, B1__bar, C2__bar);
	and (int_fwire_11, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_12, A1__bar, B3__bar, C2__bar);
	and (int_fwire_13, A1__bar, B3__bar, C1__bar);
	and (int_fwire_14, A1__bar, B2__bar, C2__bar);
	and (int_fwire_15, A1__bar, B2__bar, C1__bar);
	and (int_fwire_16, A1__bar, B1__bar, C2__bar);
	and (int_fwire_17, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI333xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, C2__bar, C3__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;
	wire int_fwire_9, int_fwire_10, int_fwire_11;
	wire int_fwire_12, int_fwire_13, int_fwire_14;
	wire int_fwire_15, int_fwire_16, int_fwire_17;
	wire int_fwire_18, int_fwire_19, int_fwire_20;
	wire int_fwire_21, int_fwire_22, int_fwire_23;
	wire int_fwire_24, int_fwire_25, int_fwire_26;

	not (C3__bar, C3);
	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar, C3__bar);
	not (C2__bar, C2);
	and (int_fwire_1, A3__bar, B3__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_2, A3__bar, B3__bar, C1__bar);
	not (B2__bar, B2);
	and (int_fwire_3, A3__bar, B2__bar, C3__bar);
	and (int_fwire_4, A3__bar, B2__bar, C2__bar);
	and (int_fwire_5, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_6, A3__bar, B1__bar, C3__bar);
	and (int_fwire_7, A3__bar, B1__bar, C2__bar);
	and (int_fwire_8, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_9, A2__bar, B3__bar, C3__bar);
	and (int_fwire_10, A2__bar, B3__bar, C2__bar);
	and (int_fwire_11, A2__bar, B3__bar, C1__bar);
	and (int_fwire_12, A2__bar, B2__bar, C3__bar);
	and (int_fwire_13, A2__bar, B2__bar, C2__bar);
	and (int_fwire_14, A2__bar, B2__bar, C1__bar);
	and (int_fwire_15, A2__bar, B1__bar, C3__bar);
	and (int_fwire_16, A2__bar, B1__bar, C2__bar);
	and (int_fwire_17, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_18, A1__bar, B3__bar, C3__bar);
	and (int_fwire_19, A1__bar, B3__bar, C2__bar);
	and (int_fwire_20, A1__bar, B3__bar, C1__bar);
	and (int_fwire_21, A1__bar, B2__bar, C3__bar);
	and (int_fwire_22, A1__bar, B2__bar, C2__bar);
	and (int_fwire_23, A1__bar, B2__bar, C1__bar);
	and (int_fwire_24, A1__bar, B1__bar, C3__bar);
	and (int_fwire_25, A1__bar, B1__bar, C2__bar);
	and (int_fwire_26, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_26, int_fwire_25, int_fwire_24, int_fwire_23, int_fwire_22, int_fwire_21, int_fwire_20, int_fwire_19, int_fwire_18, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module AOI33xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3);
	output Y;
	input A1, A2, A3, B1, B2, B3;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;

	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar);
	not (B2__bar, B2);
	and (int_fwire_1, A3__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A3__bar, B1__bar);
	not (A2__bar, A2);
	and (int_fwire_3, A2__bar, B3__bar);
	and (int_fwire_4, A2__bar, B2__bar);
	and (int_fwire_5, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_6, A1__bar, B3__bar);
	and (int_fwire_7, A1__bar, B2__bar);
	and (int_fwire_8, A1__bar, B1__bar);
	or (Y, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// ---- OA (from ORFS asap7 stdcell models; UDPs and specify blocks removed)
// BSD 3-Clause License
// 
// Copyright 2020 Lawrence T. Clark, Vinay Vashishtha, or Arizona State
// University
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// Verilog for library /home/ltclark/ASAP7/LIB2/Liberate_2/Verilog/asap7sc7p5t_OA_RVT_TT_201020 created by Liberate 18.1.0.293 on Sat Nov 28 13:55:21 MST 2020 for SDF version 2.1

// type:  


module O2A1O1Ixp33_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	and (int_fwire_0, B__bar, C__bar);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar, C__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module O2A1O1Ixp5_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	and (int_fwire_0, B__bar, C__bar);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar, C__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA211x2_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, A2, B, C);
	and (int_fwire_1, A1, B, C);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA21x2_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, A2, B);
	and (int_fwire_1, A1, B);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA221x2_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3;

	and (int_fwire_0, A2, B2, C);
	and (int_fwire_1, A2, B1, C);
	and (int_fwire_2, A1, B2, C);
	and (int_fwire_3, A1, B1, C);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA222x2_ASAP7_75t_R (Y, A1, A2, B1, B2, C1, C2);
	output Y;
	input A1, A2, B1, B2, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7;

	and (int_fwire_0, A2, B2, C2);
	and (int_fwire_1, A2, B2, C1);
	and (int_fwire_2, A2, B1, C2);
	and (int_fwire_3, A2, B1, C1);
	and (int_fwire_4, A1, B2, C2);
	and (int_fwire_5, A1, B2, C1);
	and (int_fwire_6, A1, B1, C2);
	and (int_fwire_7, A1, B1, C1);
	or (Y, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA22x2_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3;

	and (int_fwire_0, A2, B2);
	and (int_fwire_1, A2, B1);
	and (int_fwire_2, A1, B2);
	and (int_fwire_3, A1, B1);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA31x2_ASAP7_75t_R (Y, A1, A2, A3, B1);
	output Y;
	input A1, A2, A3, B1;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, A3, B1);
	and (int_fwire_1, A2, B1);
	and (int_fwire_2, A1, B1);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA331x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;

	and (int_fwire_0, A3, B3, C1);
	and (int_fwire_1, A3, B2, C1);
	and (int_fwire_2, A3, B1, C1);
	and (int_fwire_3, A2, B3, C1);
	and (int_fwire_4, A2, B2, C1);
	and (int_fwire_5, A2, B1, C1);
	and (int_fwire_6, A1, B3, C1);
	and (int_fwire_7, A1, B2, C1);
	and (int_fwire_8, A1, B1, C1);
	or (Y, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA331x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;

	and (int_fwire_0, A3, B3, C1);
	and (int_fwire_1, A3, B2, C1);
	and (int_fwire_2, A3, B1, C1);
	and (int_fwire_3, A2, B3, C1);
	and (int_fwire_4, A2, B2, C1);
	and (int_fwire_5, A2, B1, C1);
	and (int_fwire_6, A1, B3, C1);
	and (int_fwire_7, A1, B2, C1);
	and (int_fwire_8, A1, B1, C1);
	or (Y, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA332x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;
	wire int_fwire_9, int_fwire_10, int_fwire_11;
	wire int_fwire_12, int_fwire_13, int_fwire_14;
	wire int_fwire_15, int_fwire_16, int_fwire_17;

	and (int_fwire_0, A3, B3, C2);
	and (int_fwire_1, A3, B3, C1);
	and (int_fwire_2, A3, B2, C2);
	and (int_fwire_3, A3, B2, C1);
	and (int_fwire_4, A3, B1, C2);
	and (int_fwire_5, A3, B1, C1);
	and (int_fwire_6, A2, B3, C2);
	and (int_fwire_7, A2, B3, C1);
	and (int_fwire_8, A2, B2, C2);
	and (int_fwire_9, A2, B2, C1);
	and (int_fwire_10, A2, B1, C2);
	and (int_fwire_11, A2, B1, C1);
	and (int_fwire_12, A1, B3, C2);
	and (int_fwire_13, A1, B3, C1);
	and (int_fwire_14, A1, B2, C2);
	and (int_fwire_15, A1, B2, C1);
	and (int_fwire_16, A1, B1, C2);
	and (int_fwire_17, A1, B1, C1);
	or (Y, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA332x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;
	wire int_fwire_9, int_fwire_10, int_fwire_11;
	wire int_fwire_12, int_fwire_13, int_fwire_14;
	wire int_fwire_15, int_fwire_16, int_fwire_17;

	and (int_fwire_0, A3, B3, C2);
	and (int_fwire_1, A3, B3, C1);
	and (int_fwire_2, A3, B2, C2);
	and (int_fwire_3, A3, B2, C1);
	and (int_fwire_4, A3, B1, C2);
	and (int_fwire_5, A3, B1, C1);
	and (int_fwire_6, A2, B3, C2);
	and (int_fwire_7, A2, B3, C1);
	and (int_fwire_8, A2, B2, C2);
	and (int_fwire_9, A2, B2, C1);
	and (int_fwire_10, A2, B1, C2);
	and (int_fwire_11, A2, B1, C1);
	and (int_fwire_12, A1, B3, C2);
	and (int_fwire_13, A1, B3, C1);
	and (int_fwire_14, A1, B2, C2);
	and (int_fwire_15, A1, B2, C1);
	and (int_fwire_16, A1, B1, C2);
	and (int_fwire_17, A1, B1, C1);
	or (Y, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA333x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;
	wire int_fwire_9, int_fwire_10, int_fwire_11;
	wire int_fwire_12, int_fwire_13, int_fwire_14;
	wire int_fwire_15, int_fwire_16, int_fwire_17;
	wire int_fwire_18, int_fwire_19, int_fwire_20;
	wire int_fwire_21, int_fwire_22, int_fwire_23;
	wire int_fwire_24, int_fwire_25, int_fwire_26;

	and (int_fwire_0, A3, B3, C3);
	and (int_fwire_1, A3, B3, C2);
	and (int_fwire_2, A3, B3, C1);
	and (int_fwire_3, A3, B2, C3);
	and (int_fwire_4, A3, B2, C2);
	and (int_fwire_5, A3, B2, C1);
	and (int_fwire_6, A3, B1, C3);
	and (int_fwire_7, A3, B1, C2);
	and (int_fwire_8, A3, B1, C1);
	and (int_fwire_9, A2, B3, C3);
	and (int_fwire_10, A2, B3, C2);
	and (int_fwire_11, A2, B3, C1);
	and (int_fwire_12, A2, B2, C3);
	and (int_fwire_13, A2, B2, C2);
	and (int_fwire_14, A2, B2, C1);
	and (int_fwire_15, A2, B1, C3);
	and (int_fwire_16, A2, B1, C2);
	and (int_fwire_17, A2, B1, C1);
	and (int_fwire_18, A1, B3, C3);
	and (int_fwire_19, A1, B3, C2);
	and (int_fwire_20, A1, B3, C1);
	and (int_fwire_21, A1, B2, C3);
	and (int_fwire_22, A1, B2, C2);
	and (int_fwire_23, A1, B2, C1);
	and (int_fwire_24, A1, B1, C3);
	and (int_fwire_25, A1, B1, C2);
	and (int_fwire_26, A1, B1, C1);
	or (Y, int_fwire_26, int_fwire_25, int_fwire_24, int_fwire_23, int_fwire_22, int_fwire_21, int_fwire_20, int_fwire_19, int_fwire_18, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA333x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;
	wire int_fwire_9, int_fwire_10, int_fwire_11;
	wire int_fwire_12, int_fwire_13, int_fwire_14;
	wire int_fwire_15, int_fwire_16, int_fwire_17;
	wire int_fwire_18, int_fwire_19, int_fwire_20;
	wire int_fwire_21, int_fwire_22, int_fwire_23;
	wire int_fwire_24, int_fwire_25, int_fwire_26;

	and (int_fwire_0, A3, B3, C3);
	and (int_fwire_1, A3, B3, C2);
	and (int_fwire_2, A3, B3, C1);
	and (int_fwire_3, A3, B2, C3);
	and (int_fwire_4, A3, B2, C2);
	and (int_fwire_5, A3, B2, C1);
	and (int_fwire_6, A3, B1, C3);
	and (int_fwire_7, A3, B1, C2);
	and (int_fwire_8, A3, B1, C1);
	and (int_fwire_9, A2, B3, C3);
	and (int_fwire_10, A2, B3, C2);
	and (int_fwire_11, A2, B3, C1);
	and (int_fwire_12, A2, B2, C3);
	and (int_fwire_13, A2, B2, C2);
	and (int_fwire_14, A2, B2, C1);
	and (int_fwire_15, A2, B1, C3);
	and (int_fwire_16, A2, B1, C2);
	and (int_fwire_17, A2, B1, C1);
	and (int_fwire_18, A1, B3, C3);
	and (int_fwire_19, A1, B3, C2);
	and (int_fwire_20, A1, B3, C1);
	and (int_fwire_21, A1, B2, C3);
	and (int_fwire_22, A1, B2, C2);
	and (int_fwire_23, A1, B2, C1);
	and (int_fwire_24, A1, B1, C3);
	and (int_fwire_25, A1, B1, C2);
	and (int_fwire_26, A1, B1, C1);
	or (Y, int_fwire_26, int_fwire_25, int_fwire_24, int_fwire_23, int_fwire_22, int_fwire_21, int_fwire_20, int_fwire_19, int_fwire_18, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OA33x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3);
	output Y;
	input A1, A2, A3, B1, B2, B3;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;

	and (int_fwire_0, A3, B3);
	and (int_fwire_1, A3, B2);
	and (int_fwire_2, A3, B1);
	and (int_fwire_3, A2, B3);
	and (int_fwire_4, A2, B2);
	and (int_fwire_5, A2, B1);
	and (int_fwire_6, A1, B3);
	and (int_fwire_7, A1, B2);
	and (int_fwire_8, A1, B1);
	or (Y, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI211xp5_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0;

	not (C__bar, C);
	not (B__bar, B);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2__bar);
	or (Y, int_fwire_0, B__bar, C__bar);

	// Timing

endmodule


// type:  


module OAI21x1_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0;

	not (B__bar, B);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2__bar);
	or (Y, int_fwire_0, B__bar);

	// Timing

endmodule


// type:  


module OAI21xp33_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0;

	not (B__bar, B);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2__bar);
	or (Y, int_fwire_0, B__bar);

	// Timing

endmodule


// type:  


module OAI21xp5_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0;

	not (B__bar, B);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2__bar);
	or (Y, int_fwire_0, B__bar);

	// Timing

endmodule


// type:  


module OAI221xp5_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C__bar, int_fwire_0;
	wire int_fwire_1;

	not (C__bar, C);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar);
	or (Y, int_fwire_1, int_fwire_0, C__bar);

	// Timing

endmodule


// type:  


module OAI222xp33_ASAP7_75t_R (Y, A1, A2, B1, B2, C1, C2);
	output Y;
	input A1, A2, B1, B2, C1, C2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C1__bar, C2__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	not (C2__bar, C2);
	not (C1__bar, C1);
	and (int_fwire_0, C1__bar, C2__bar);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_1, B1__bar, B2__bar);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, A2__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI22x1_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;

	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI22xp33_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;

	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI22xp5_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;

	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI311xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, C1);
	output Y;
	input A1, A2, A3, B1, C1;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, C1__bar, int_fwire_0;

	not (C1__bar, C1);
	not (B1__bar, B1);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_0, B1__bar, C1__bar);

	// Timing

endmodule


// type:  


module OAI31xp33_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, int_fwire_0;

	not (B__bar, B);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_0, B__bar);

	// Timing

endmodule


// type:  


module OAI31xp67_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, int_fwire_0;

	not (B__bar, B);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_0, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_0, B__bar);

	// Timing

endmodule


// type:  


module OAI321xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C);
	output Y;
	input A1, A2, A3, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, C__bar;
	wire int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_1, int_fwire_0, C__bar);

	// Timing

endmodule


// type:  


module OAI322xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, C1, C2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, C1__bar;
	wire C2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2;

	not (C2__bar, C2);
	not (C1__bar, C1);
	and (int_fwire_0, C1__bar, C2__bar);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_1, B1__bar, B2__bar);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI32xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2);
	output Y;
	input A1, A2, A3, B1, B2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, int_fwire_0;
	wire int_fwire_1;

	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI331xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, int_fwire_0, int_fwire_1;

	not (C1__bar, C1);
	not (B3__bar, B3);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar, B3__bar);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_1, int_fwire_0, C1__bar);

	// Timing

endmodule


// type:  


module OAI332xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, C2__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2;

	not (C2__bar, C2);
	not (C1__bar, C1);
	and (int_fwire_0, C1__bar, C2__bar);
	not (B3__bar, B3);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_1, B1__bar, B2__bar, B3__bar);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI333xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, C2__bar, C3__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	not (C3__bar, C3);
	not (C2__bar, C2);
	not (C1__bar, C1);
	and (int_fwire_0, C1__bar, C2__bar, C3__bar);
	not (B3__bar, B3);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_1, B1__bar, B2__bar, B3__bar);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module OAI33xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3);
	output Y;
	input A1, A2, A3, B1, B2, B3;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire int_fwire_0, int_fwire_1;

	not (B3__bar, B3);
	not (B2__bar, B2);
	not (B1__bar, B1);
	and (int_fwire_0, B1__bar, B2__bar, B3__bar);
	not (A3__bar, A3);
	not (A2__bar, A2);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, A2__bar, A3__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule



`ifdef _udp_def_altos_latch_
`else
`define _udp_def_altos_latch_

`endif

`ifdef _udp_def_altos_dff_err_
`else
`define _udp_def_altos_dff_err_

`endif

`ifdef _udp_def_altos_dff_
`else
`define _udp_def_altos_dff_

`endif

`ifdef _udp_def_altos_dff_r_err_
`else
`define _udp_def_altos_dff_r_err_

`endif

`ifdef _udp_def_altos_dff_r_
`else
`define _udp_def_altos_dff_r_

`endif

`ifdef _udp_def_altos_dff_s_err_
`else
`define _udp_def_altos_dff_s_err_

`endif

`ifdef _udp_def_altos_dff_s_
`else
`define _udp_def_altos_dff_s_

`endif

`ifdef _udp_def_altos_dff_sr_err_
`else
`define _udp_def_altos_dff_sr_err_

`endif

`ifdef _udp_def_altos_dff_sr_0
`else
`define _udp_def_altos_dff_sr_0

`endif

`ifdef _udp_def_altos_dff_sr_1
`else
`define _udp_def_altos_dff_sr_1

`endif

`ifdef _udp_def_altos_latch_r_
`else
`define _udp_def_altos_latch_r_

`endif

`ifdef _udp_def_altos_latch_s_
`else
`define _udp_def_altos_latch_s_

`endif

`ifdef _udp_def_altos_latch_sr_0
`else
`define _udp_def_altos_latch_sr_0

`endif

`ifdef _udp_def_altos_latch_sr_1
`else
`define _udp_def_altos_latch_sr_1

`endif

// ---- SIMPLE (from ORFS asap7 stdcell models; UDPs and specify blocks removed)
// BSD 3-Clause License
// 
// Copyright 2020 Lawrence T. Clark, Vinay Vashishtha, or Arizona State
// University
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// Verilog for library /home/ltclark/ASAP7/LIB2/Liberate_2/Verilog/asap7sc7p5t_SIMPLE_RVT_TT_201020 created by Liberate 18.1.0.293 on Fri Nov 27 12:35:46 MST 2020 for SDF version 2.1

// type:  


module AND2x2_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	and (Y, A, B);

	// Timing

endmodule


// type:  


module AND2x4_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	and (Y, A, B);

	// Timing

endmodule


// type:  


module AND2x6_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	and (Y, A, B);

	// Timing

endmodule


// type:  


module AND3x1_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	and (Y, A, B, C);

	// Timing

endmodule


// type:  


module AND3x2_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	and (Y, A, B, C);

	// Timing

endmodule


// type:  


module AND3x4_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	and (Y, A, B, C);

	// Timing

endmodule


// type:  


module AND4x1_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	and (Y, A, B, C, D);

	// Timing

endmodule


// type:  


module AND4x2_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	and (Y, A, B, C, D);

	// Timing

endmodule


// type:  


module AND5x1_ASAP7_75t_R (Y, A, B, C, D, E);
	output Y;
	input A, B, C, D, E;

	// Function
	and (Y, A, B, C, D, E);

	// Timing

endmodule


// type:  


module AND5x2_ASAP7_75t_R (Y, A, B, C, D, E);
	output Y;
	input A, B, C, D, E;

	// Function
	and (Y, A, B, C, D, E);

	// Timing

endmodule


// type:  


module FAx1_ASAP7_75t_R (CON, SN, A, B, CI);
	output CON, SN;
	input A, B, CI;

	// Function
	wire A__bar, B__bar, CI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6;

	not (CI__bar, CI);
	not (B__bar, B);
	and (int_fwire_0, B__bar, CI__bar);
	not (A__bar, A);
	and (int_fwire_1, A__bar, CI__bar);
	and (int_fwire_2, A__bar, B__bar);
	or (CON, int_fwire_2, int_fwire_1, int_fwire_0);
	and (int_fwire_3, A__bar, B__bar, CI__bar);
	and (int_fwire_4, A__bar, B, CI);
	and (int_fwire_5, A, B__bar, CI);
	and (int_fwire_6, A, B, CI__bar);
	or (SN, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3);

	// Timing

endmodule


// type:  


module HAxp5_ASAP7_75t_R (CON, SN, A, B);
	output CON, SN;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (B__bar, B);
	not (A__bar, A);
	or (CON, A__bar, B__bar);
	and (int_fwire_0, A__bar, B__bar);
	and (int_fwire_1, A, B);
	or (SN, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module MAJIxp5_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	not (C__bar, C);
	not (B__bar, B);
	and (int_fwire_0, B__bar, C__bar);
	not (A__bar, A);
	and (int_fwire_1, A__bar, C__bar);
	and (int_fwire_2, A__bar, B__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module MAJx2_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, B, C);
	and (int_fwire_1, A, C);
	and (int_fwire_2, A, B);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module MAJx3_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, B, C);
	and (int_fwire_1, A, C);
	and (int_fwire_2, A, B);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module NAND2x1_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NAND2x1p5_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NAND2x2_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NAND2xp33_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NAND2xp5_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NAND2xp67_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NAND3x1_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;

	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar, C__bar);

	// Timing

endmodule


// type:  


module NAND3x2_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;

	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar, C__bar);

	// Timing

endmodule


// type:  


module NAND3xp33_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;

	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar, C__bar);

	// Timing

endmodule


// type:  


module NAND4xp25_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	wire A__bar, B__bar, C__bar;
	wire D__bar;

	not (D__bar, D);
	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar, C__bar, D__bar);

	// Timing

endmodule


// type:  


module NAND4xp75_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	wire A__bar, B__bar, C__bar;
	wire D__bar;

	not (D__bar, D);
	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar, C__bar, D__bar);

	// Timing

endmodule


// type:  


module NAND5xp2_ASAP7_75t_R (Y, A, B, C, D, E);
	output Y;
	input A, B, C, D, E;

	// Function
	wire A__bar, B__bar, C__bar;
	wire D__bar, E__bar;

	not (E__bar, E);
	not (D__bar, D);
	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	or (Y, A__bar, B__bar, C__bar, D__bar, E__bar);

	// Timing

endmodule


// type:  


module NOR2x1_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NOR2x1p5_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NOR2x2_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NOR2xp33_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NOR2xp67_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar;

	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar);

	// Timing

endmodule


// type:  


module NOR3x1_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;

	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar, C__bar);

	// Timing

endmodule


// type:  


module NOR3x2_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;

	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar, C__bar);

	// Timing

endmodule


// type:  


module NOR3xp33_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	wire A__bar, B__bar, C__bar;

	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar, C__bar);

	// Timing

endmodule


// type:  


module NOR4xp25_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	wire A__bar, B__bar, C__bar;
	wire D__bar;

	not (D__bar, D);
	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar, C__bar, D__bar);

	// Timing

endmodule


// type:  


module NOR4xp75_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	wire A__bar, B__bar, C__bar;
	wire D__bar;

	not (D__bar, D);
	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar, C__bar, D__bar);

	// Timing

endmodule


// type:  


module NOR5xp2_ASAP7_75t_R (Y, A, B, C, D, E);
	output Y;
	input A, B, C, D, E;

	// Function
	wire A__bar, B__bar, C__bar;
	wire D__bar, E__bar;

	not (E__bar, E);
	not (D__bar, D);
	not (C__bar, C);
	not (B__bar, B);
	not (A__bar, A);
	and (Y, A__bar, B__bar, C__bar, D__bar, E__bar);

	// Timing

endmodule


// type:  


module OR2x2_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	or (Y, A, B);

	// Timing

endmodule


// type:  


module OR2x4_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	or (Y, A, B);

	// Timing

endmodule


// type:  


module OR2x6_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	or (Y, A, B);

	// Timing

endmodule


// type:  


module OR3x1_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	or (Y, A, B, C);

	// Timing

endmodule


// type:  


module OR3x2_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	or (Y, A, B, C);

	// Timing

endmodule


// type:  


module OR3x4_ASAP7_75t_R (Y, A, B, C);
	output Y;
	input A, B, C;

	// Function
	or (Y, A, B, C);

	// Timing

endmodule


// type:  


module OR4x1_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	or (Y, A, B, C, D);

	// Timing

endmodule


// type:  


module OR4x2_ASAP7_75t_R (Y, A, B, C, D);
	output Y;
	input A, B, C, D;

	// Function
	or (Y, A, B, C, D);

	// Timing

endmodule


// type:  


module OR5x1_ASAP7_75t_R (Y, A, B, C, D, E);
	output Y;
	input A, B, C, D, E;

	// Function
	or (Y, A, B, C, D, E);

	// Timing

endmodule


// type:  


module OR5x2_ASAP7_75t_R (Y, A, B, C, D, E);
	output Y;
	input A, B, C, D, E;

	// Function
	or (Y, A, B, C, D, E);

	// Timing

endmodule


// type:  


module TIEHIx1_ASAP7_75t_R (H);
	output H;

	// Function
	buf (H, 1'b1);

	// Timing

endmodule


// type:  


module TIELOx1_ASAP7_75t_R (L);
	output L;

	// Function
	buf (L, 1'b0);

	// Timing

endmodule


// type:  


module XNOR2x1_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (B__bar, B);
	not (A__bar, A);
	and (int_fwire_0, A__bar, B__bar);
	and (int_fwire_1, A, B);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module XNOR2x2_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (B__bar, B);
	not (A__bar, A);
	and (int_fwire_0, A__bar, B__bar);
	and (int_fwire_1, A, B);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module XNOR2xp5_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (B__bar, B);
	not (A__bar, A);
	and (int_fwire_0, A__bar, B__bar);
	and (int_fwire_1, A, B);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module XOR2x1_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (A__bar, A);
	and (int_fwire_0, A__bar, B);
	not (B__bar, B);
	and (int_fwire_1, A, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module XOR2x2_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (A__bar, A);
	and (int_fwire_0, A__bar, B);
	not (B__bar, B);
	and (int_fwire_1, A, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule


// type:  


module XOR2xp5_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (A__bar, A);
	and (int_fwire_0, A__bar, B);
	not (B__bar, B);
	and (int_fwire_1, A, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing

endmodule



`ifdef _udp_def_altos_latch_
`else
`define _udp_def_altos_latch_

`endif

`ifdef _udp_def_altos_dff_err_
`else
`define _udp_def_altos_dff_err_

`endif

`ifdef _udp_def_altos_dff_
`else
`define _udp_def_altos_dff_

`endif

`ifdef _udp_def_altos_dff_r_err_
`else
`define _udp_def_altos_dff_r_err_

`endif

`ifdef _udp_def_altos_dff_r_
`else
`define _udp_def_altos_dff_r_

`endif

`ifdef _udp_def_altos_dff_s_err_
`else
`define _udp_def_altos_dff_s_err_

`endif

`ifdef _udp_def_altos_dff_s_
`else
`define _udp_def_altos_dff_s_

`endif

`ifdef _udp_def_altos_dff_sr_err_
`else
`define _udp_def_altos_dff_sr_err_

`endif

`ifdef _udp_def_altos_dff_sr_0
`else
`define _udp_def_altos_dff_sr_0

`endif

`ifdef _udp_def_altos_dff_sr_1
`else
`define _udp_def_altos_dff_sr_1

`endif

`ifdef _udp_def_altos_latch_r_
`else
`define _udp_def_altos_latch_r_

`endif

`ifdef _udp_def_altos_latch_s_
`else
`define _udp_def_altos_latch_s_

`endif

`ifdef _udp_def_altos_latch_sr_0
`else
`define _udp_def_altos_latch_sr_0

`endif

`ifdef _udp_def_altos_latch_sr_1
`else
`define _udp_def_altos_latch_sr_1

`endif

// ---- INVBUF (from ORFS asap7 stdcell models; UDPs and specify blocks removed)
// BSD 3-Clause License
// 
// Copyright 2020 Lawrence T. Clark, Vinay Vashishtha, or Arizona State
// University
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// Verilog for library /home/ltclark/ASAP7/LIB2/Liberate_2/Verilog/asap7sc7p5t_INVBUF_RVT_TT_201020 created by Liberate 18.1.0.293 on Mon Dec  7 13:57:05 MST 2020 for SDF version 2.1

// type:  


module BUFx10_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx12_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx12f_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx16f_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx24_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx2_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx3_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx4_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx4f_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx5_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx6f_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module BUFx8_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx10_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx11_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx12_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx14_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx16_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx20_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx5p33_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx6p67_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx8_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module CKINVDCx9p33_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module HB1xp67_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module HB2xp67_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module HB3xp67_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module HB4xp67_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	buf (Y, A);

	// Timing

endmodule


// type:  


module INVx11_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx13_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx1_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx2_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx3_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx4_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx5_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx6_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVx8_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVxp33_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule


// type:  


module INVxp67_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

	// Timing

endmodule



`ifdef _udp_def_altos_latch_
`else
`define _udp_def_altos_latch_

`endif

`ifdef _udp_def_altos_dff_err_
`else
`define _udp_def_altos_dff_err_

`endif

`ifdef _udp_def_altos_dff_
`else
`define _udp_def_altos_dff_

`endif

`ifdef _udp_def_altos_dff_r_err_
`else
`define _udp_def_altos_dff_r_err_

`endif

`ifdef _udp_def_altos_dff_r_
`else
`define _udp_def_altos_dff_r_

`endif

`ifdef _udp_def_altos_dff_s_err_
`else
`define _udp_def_altos_dff_s_err_

`endif

`ifdef _udp_def_altos_dff_s_
`else
`define _udp_def_altos_dff_s_

`endif

`ifdef _udp_def_altos_dff_sr_err_
`else
`define _udp_def_altos_dff_sr_err_

`endif

`ifdef _udp_def_altos_dff_sr_0
`else
`define _udp_def_altos_dff_sr_0

`endif

`ifdef _udp_def_altos_dff_sr_1
`else
`define _udp_def_altos_dff_sr_1

`endif

`ifdef _udp_def_altos_latch_r_
`else
`define _udp_def_altos_latch_r_

`endif

`ifdef _udp_def_altos_latch_s_
`else
`define _udp_def_altos_latch_s_

`endif

`ifdef _udp_def_altos_latch_sr_0
`else
`define _udp_def_altos_latch_sr_0

`endif

`ifdef _udp_def_altos_latch_sr_1
`else
`define _udp_def_altos_latch_sr_1

`endif
