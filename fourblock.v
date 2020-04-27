`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:12 02/04/2020 
// Design Name: 
// Module Name:    fourblock 
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
module fourblock(
    input wire signed [63:0] amps,
    input wire [63:0] offsets,
    input wire [63:0] phasewords,
    input wire clk,
    input wire reset,
    output wire signed [15:0] results
    );

	wire signed [15:0] a, b;;
	
	twoblock twoblockOne(
		.amps(amps[63:32]),
		.offsets(offsets[63:32]),
		.phasewords(phasewords[63:32]),
		.clk(clk),
		.reset(reset),
		.results(a)
	);
	
	twoblock twoblockZero(
		.amps(amps[31:0]),
		.offsets(offsets[31:0]),
		.phasewords(phasewords[31:0]),
		.clk(clk),
		.reset(reset),
		.results(b)
	);
	
	clockedadd adder(
		.a(a),
		.b(b),
		.clk(clk),
		.sum(results)
	);
endmodule