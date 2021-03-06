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
	
	sixteenblock sixteenblockOne(
		.amps(amps[511:256]),
		.offsets(offsets[511:256]),
		.phasewords(phasewords[511:256]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(a),
		.activeout(activea)
	);
	
	sixteenblock sixteenblockZero(
		.amps(amps[255:0]),
		.offsets(offsets[255:0]),
		.phasewords(phasewords[255:0]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(b),
		.activeout(activeb)
	);
	
endmodule