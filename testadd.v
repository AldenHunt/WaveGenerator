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
module testcompute(
    input wire [15:0] amp,
    input wire [15:0] freq,
    input wire [15:0] phase,
	 input wire [15:0] t,
    output wire [31:0] result
    );

	assign result = amp * ((freq * t) + phase);
	
endmodule
