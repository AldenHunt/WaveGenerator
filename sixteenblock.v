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

	eightblock eightblockOne(
		.amps(amps[255:128]),
		.offsets(offsets[255:128]),
		.phasewords(phasewords[255:128]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(a),
		.activeout(activea)
	);
	
	eightblock eightblockZero(
		.amps(amps[127:0]),
		.offsets(offsets[127:0]),
		.phasewords(phasewords[127:0]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(b),
		.activeout(activeb)
	);
	
endmodule