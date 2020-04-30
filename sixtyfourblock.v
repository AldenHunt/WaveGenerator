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
	
	thirtytwoblock thirtytwoblockOne(
		.amps(amps[1023:512]),
		.offsets(offsets[1023:512]),
		.phasewords(phasewords[1023:512]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(a),
		.activeout(activea)
	);
	
	thirtytwoblock thirtytwoblockZero(
		.amps(amps[511:0]),
		.offsets(offsets[511:0]),
		.phasewords(phasewords[511:0]),
		.clk(clk),
		.reset(reset),
		.activein(activein),
		.results(b),
		.activeout(activeb)
	);
	
	


endmodule