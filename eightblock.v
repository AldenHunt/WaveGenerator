`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:12 02/04/2020 
// Design Name: 
// Module Name:    eightblock 
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
module eightblock(
    input wire signed [127:0] amps,
    input wire [127:0] offsets,
    input wire [127:0] phasewords,
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
	
	fourblock fourblockOne(
		.amps(amps[127:64]),
		.offsets(offsets[127:64]),
		.phasewords(phasewords[127:64]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(a),
		.activeout(activea)
	);
	
	fourblock fourblockZero(
		.amps(amps[63:0]),
		.offsets(offsets[63:0]),
		.phasewords(phasewords[63:0]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(b),
		.activeout(activeb)
	);

	
endmodule