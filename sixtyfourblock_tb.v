`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:24:40 04/27/2020
// Design Name:   sixtyfourblock
// Module Name:   /home/ise/ise_projects/Thesis/sixtyfourblock_tb.v
// Project Name:  Thesis
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sixtyfourblock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sixtyfourblock_tb;

	// Inputs
	reg [1023:0] amps;
	reg [1023:0] offsets;
	reg [1023:0] phasewords;
	reg clk;
	reg reset;

	// Outputs
	wire [15:0] results;
	
	//loop variable
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	sixtyfourblock uut (
		.amps(amps), 
		.offsets(offsets), 
		.phasewords(phasewords), 
		.clk(clk), 
		.reset(reset), 
		.results(results)
	);

	initial begin
		// Initialize Inputs
		amps = 0;
		offsets = 0;
		phasewords = 0;
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		amps = 1024'h1000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000;
		phasewords = 1024'h0001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001;
		#5;
		reset = 1;
		clk = 1;
		#5;
		reset = 1'b0;
		clk = 0;
		#5;
		
		for (i=0; i<3000; i=i+1) begin
			clk = 1;
			#2;
			clk = 0;
			#2;
      end
		
	end
      
endmodule

