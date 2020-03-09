`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:12 02/04/2020 
// Design Name: 
// Module Name:    sixtyfourblock 
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
module sixtyfourblock(
    input wire signed [1023:0] amps,
    input wire [1023:0] offsets,
    input wire [1023:0] phasewords,
    input wire [63:0] clks,
    input wire reset,
    output reg signed [15:0] results
    );

	wire signed [15:0] a, b;
	
	thirtytwoblock thirtytwoblockOne(
		.amps(amps[1023:512]),
		.offsets(offsets[1023:512]),
		.phasewords(phasewords[1023:512]),
		.clks(clks[63:32]),
		.reset(reset),
		.results(a)
	);
	
	thirtytwoblock thirtytwoblockZero(
		.amps(amps[511:0]),
		.offsets(offsets[511:0]),
		.phasewords(phasewords[511:0]),
		.clks(clks[31:0]),
		.reset(reset),
		.results(b)
	);
	
	always@(*) begin
		results = a + b;
	end
	
endmodule