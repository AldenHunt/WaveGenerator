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
module singlecompute(
    input wire signed [15:0] amp,
    input wire [15:0] phaseoffset,
	 input wire [15:0] phaseadd,
	 input wire clk,
	 input wire reset,
	 input wire activein,
    output reg signed [15:0] result,
	 output reg activeout
    );

	wire signed [9:0] sineresult;
	reg signed [24:0] interimresult;
	reg [15:0] totalphase;
	
	always@(*) begin
		interimresult = amp * sineresult;
		if (interimresult == 25'h1000000) begin //Max value and only overflow into 31st bit
			result = $signed(16'h7fff) >>> 6;
		end else begin
			result = $signed(interimresult[24:9]) >>> 6;
		end
	end
	
	always@(posedge clk) begin
		activeout <= activein;
		if (reset)
			totalphase <= phaseoffset;
		else
			totalphase <= totalphase + phaseadd;
	end
	
	sinetable sinl(
		.phase(totalphase[15:4]),
		.result(sineresult)
	);
	
endmodule
