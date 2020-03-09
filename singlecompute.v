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
    output reg signed [15:0] result
    );

	wire signed [11:0] sineresult;
	reg signed [15:0] signedsine;
	reg signed [31:0] interimresult;
	reg [15:0] totalphase;
	
	always@(*) begin
		signedsine = sineresult <<< 4;
		interimresult = amp * signedsine;
		if (interimresult == 32'h40000000) begin //Max value and only overflow into 31st bit
			result = $signed(16'h7fff) >>> 6;
		end else begin
			result = $signed(interimresult[30:15]) >>> 6;
		end
	end
	
	always@(posedge clk) begin
		if (reset)
			totalphase <= phaseoffset;
		else
			totalphase <= totalphase + phaseadd;
	end
	
	sinetable sinl(
		.phase(totalphase[15:2]),
		.result(sineresult)
	);
	
endmodule
