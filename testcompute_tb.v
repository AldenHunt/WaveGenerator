`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:07:54 01/08/2020
// Design Name:   testcompute
// Module Name:   /home/ise/ise_projects/Thesis/testcompute_tb.v
// Project Name:  Thesis
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: testcompute
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testcompute_tb;

	// Inputs
	reg [11:0] amp;
	reg [11:0] phaseoffset;
	reg [11:0] deltat;
	reg [11:0] freq;
	reg clk;
	reg reset;

	// Outputs
	wire [11:0] result;

	// Instantiate the Unit Under Test (UUT)
	testcompute uut (
		.amp(amp), 
		.phaseoffset(phaseoffset), 
		.deltat(deltat), 
		.freq(freq), 
		.clk(clk), 
		.reset(reset), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		amp = 0;
		phaseoffset = 0;
		deltat = 0;
		freq = 0;
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		amp = 1;
		deltat = 1;
		freq = 1;
		reset = 1;
		#10 
		clk = 1;
		#10;
		reset = 0;
		forever
			#50 clk = !clk;
	end
      
endmodule

