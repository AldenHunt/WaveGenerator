`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:12 02/04/2020 
// Design Name: 
// Module Name:    sixteenblock 
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
module sixteenblock(
    input wire signed [255:0] amps,
    input wire [255:0] offsets,
    input wire [255:0] phasewords,
    input wire [15:0] clks,
    input wire reset,
    output reg signed [15:0] results
    );

	wire signed [15:0] a, b;

	eightblock eightblockOne(
		.amps(amps[255:128]),
		.offsets(offsets[255:128]),
		.phasewords(phasewords[255:128]),
		.clks(clks[15:8]),
		.reset(reset),
		.results(a)
	);
	
	eightblock eightblockZero(
		.amps(amps[127:0]),
		.offsets(offsets[127:0]),
		.phasewords(phasewords[127:0]),
		.clks(clks[7:0]),
		.reset(reset),
		.results(b)
	);
	
	always@(*) begin
		results = a + b;
	end
	
endmodule