`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:12 02/04/2020 
// Design Name: 
// Module Name:    twoblock 
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
module twoblock(
    input wire signed [31:0] amps,
    input wire [31:0] offsets,
    input wire [31:0] phasewords,
    input wire clk,
    input wire reset,
	 input wire activein,
    output wire signed [15:0] results,
	 output wire activeout
    );

	wire signed [15:0] a, b;
	wire activea, activeb;
	
	clockedadd add(
		.a(a),
		.b(b),
		.clk(clk),
		.activea(activea),
		.activeb(activeb),
		.sum(results),
		.active(activeout)
    );
	
	singlecompute blockOne(
		.amp(amps[31:16]),
		.phaseoffset(offsets[31:16]),
		.phaseadd(phasewords[31:16]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.result(a),
		.activeout(activea)
	);
	
	singlecompute blockZero(
		.amp(amps[15:0]),
		.phaseoffset(offsets[15:0]),
		.phaseadd(phasewords[15:0]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.result(b),
		.activeout(activeb)
	);
	
endmodule
