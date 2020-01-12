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
	reg [15:0] amp;
	reg [15:0] phaseoffset;
	reg [15:0] phaseadd;
	reg clk;
	reg reset;

	// Outputs
	wire [15:0] result;

	// Instantiate the Unit Under Test (UUT)
	testcompute uut (
		.amp(amp), 
		.phaseoffset(phaseoffset), 
		.phaseadd(phaseadd), 
		.clk(clk), 
		.reset(reset), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		amp = 0;
		phaseoffset = 0;
		phaseadd = 0;
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		amp = 16'h7fff;
		phaseadd = 16'h2000;
		phaseoffset = 16'h0101;
		reset = 1;
		#10 
		clk = 1;
		#10;
		reset = 0;
		forever
			#50 clk = !clk;
	end
      
endmodule

