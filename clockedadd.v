`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:19:27 04/25/2020 
// Design Name: 
// Module Name:    clockedadd 
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
module clockedadd(
    input wire signed [15:0] a,
    input wire signed [15:0] b,
    input wire clk,
    output reg signed [15:0] sum
    );


always@(posedge clk) begin
	sum <= a + b;
end

endmodule