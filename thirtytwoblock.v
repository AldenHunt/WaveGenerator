`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:12 02/04/2020 
// Design Name: 
// Module Name:    thirtytwoblock 
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
module thirtytwoblock(
    input wire signed [511:0] amps,
    input wire [511:0] offsets,
    input wire [511:0] phasewords,
    input wire [31:0] clks,
    input wire reset,
    output reg signed [15:0] results
    );

	wire signed [15:0] a, b;
	
	sixteenblock sixteenblockOne(
		.amps(amps[511:256]),
		.offsets(offsets[511:256]),
		.phasewords(phasewords[511:256]),
		.clks(clks[31:16]),
		.reset(reset),
		.results(a)
	);
	
	sixteenblock sixteenblockZero(
		.amps(amps[255:0]),
		.offsets(offsets[255:0]),
		.phasewords(phasewords[255:0]),
		.clks(clks[15:0]),
		.reset(reset),
		.results(b)
	);
	
	always@(*) begin
		results = a + b;
	end
endmodule