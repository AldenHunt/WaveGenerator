`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:23:24 12/09/2019 
// Design Name: 
// Module Name:    testcompute 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module testcompute(
    input wire [11:0] amp,
    input wire [15:0] phaseoffset,
	 input wire [15:0] phaseadd,
	 input wire clk,
	 input wire reset,
    output reg [11:0] result
    );

	wire [11:0] sineresult;
	reg [15:0] totalphase;
	
	always@(*) begin
		result = amp * sineresult;
	end
	
	always@(posedge clk) begin
		if (reset)
			totalphase <= phaseoffset;
		else
			totalphase <= totalphase + phaseadd;
	end
	
	sinetable sinl(
		.phase(totalphase),
		.result(sineresult)
	);
	
endmodule
