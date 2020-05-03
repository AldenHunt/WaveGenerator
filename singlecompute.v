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

	reg activesinereference, activemultcoreone, activemultcoretwo;
	wire signed [7:0] sineresult;
	wire signed [23:0] interimresult;
	reg [15:0] totalphase;
	
	//Multiplier is optimized for a two clock latency
	multiplier mult (
	  .clk(clk), // input clk
	  .a(amp), // input [15 : 0] a
	  .b(sineresult), // input [7 : 0] b
	  .p(interimresult) // output [23 : 0] p
	);
	
	always@(*) begin
		if (interimresult == 24'h400000) begin //Only two max neg values overflow into 24th bit
			result = $signed(16'h01ff);
		end else begin
			result = $signed(interimresult[22:7]) >>> 6;
		end
	end
	
	always@(posedge clk) begin
		//This should synthesize to a shift register
		activeout <= activemultcoretwo;
		activemultcoretwo <= activemultcoreone;
		activemultcoreone <= activesinereference;
		activesinereference <= activein;
		
		if (reset)
			totalphase <= phaseoffset;
		else
			totalphase <= totalphase + phaseadd;
	end
	
	sinetable sinl(
		.phase(totalphase[15:4]),
		.clk(clk),
		.result(sineresult)
	);
	
endmodule
