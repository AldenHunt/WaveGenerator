`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:09:20 04/27/2020
// Design Name:   controlcombiner
// Module Name:   /home/ise/ise_projects/Thesis/controlcompiler_tb.v
// Project Name:  Thesis
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: controlcombiner
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module controlcompiler_tb;

	// Inputs
	reg [15:0] signal;
	reg [5:0] blockaddress;
	reg write;
	reg clk;

	// Outputs
	wire [1023:0] combinedout;
	//loop
	integer i;

	// Instantiate the Unit Under Test (UUT)
	controlcombiner uut (
		.signal(signal), 
		.blockaddress(blockaddress), 
		.write(write), 
		.clk(clk), 
		.combinedout(combinedout)
	);

	initial begin
		// Initialize Inputs
		signal = 0;
		blockaddress = 0;
		write = 1;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for (i=0; i<64; i=i+1) begin
			blockaddress = i;
			signal = i << 2;
			clk = 1'b1;
			#10;
			clk = 1'b0;
			#10;
      end

	end
      
endmodule

