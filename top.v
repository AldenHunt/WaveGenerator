`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:45:21 12/09/2019 
// Design Name: 
// Module Name:    top 
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

//Much of this file is boilerplate from the OK USB2.0 interface example
module top(
    input wire [7:0] hi_in,
    output wire [1:0] hi_out,
    inout wire [15:0] hi_inout,
    inout wire hi_aa,
	 
	 input wire clk1,
	 //input wire clk2,
	 //input wire clk3,
	 output wire [7:0] led
    );

	//OK Host connections
	wire ti_clk;
	wire [16:0] ok2;
	wire [30:0] ok1;
	wire [5*17-1:0] ok2x;
	
	//Endpoint connections
	wire [15:0]  resetwire;
	wire [15:0]  ampwire, offsetwire, phasewordwire, clkwire;
	wire ampwrite, offsetwrite, phasewordwrite, clkwrite;
	wire signed [15:0]  finalSum;
	
	
	//Other variables
	reg [5:0] currBlock;
	wire [1023:0] preamps, preoffsets, prephasewords;
	reg [1023:0] activeamps, activeoffsets, activephasewords;
	
	okHost okHI( 
		.hi_in(hi_in),
		.hi_out(hi_out),
		.hi_inout(hi_inout),
		.hi_aa(hi_aa),
		.ti_clk(ti_clk),
		.ok1(ok1),
		.ok2(ok2)
   );
	
	okWireOR # (.N(1)) wireOR (ok2, ok2x);
	
	always@(posedge ti_clk) begin
		if (resetwire[0] == 1) begin
			currBlock <= 0;
			activeamps <= preamps;
			activeoffsets <= preoffsets;
			activephasewords <= prephasewords;
		end
		else currBlock <= currBlock + 1;
	end
	
	controlcombiner amps(
		.signal(ampwire),
		.blockaddress(currBlock),
		.write(ampwrite),
		.clk(ti_clk),
		.combinedout(preamps)
	);
	
	controlcombiner offsets(
		.signal(offsetwire),
		.blockaddress(currBlock),
		.write(offsetwrite),
		.clk(ti_clk),
		.combinedout(preoffsets)
	);
	
	controlcombiner phasewords(
		.signal(phasewordwire),
		.blockaddress(currBlock),
		.write(phasewordwrite),
		.clk(ti_clk),
		.combinedout(prephasewords)
	);
	
	
	sixtyfourblock theBigOne(
		.amps(activeamps),
		.offsets(activeoffsets),
		.phasewords(activephasewords),
		.clk(clk1),
		.reset(resetwire),
		.results(finalSum)
	);

	assign led = finalSum[10:3];
	
	okWireIn ep03 (.ok1(ok1), .ep_addr(8'h03), .ep_dataout(resetwire));
	
	okPipeIn amppipe(.ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(ampwrite), .ep_dataout(ampwire));
	okPipeIn offsetpipe(.ok1(ok1), .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h81), .ep_write(offsetwrite), .ep_dataout(offsetwire));
	okPipeIn phasewordpipe(.ok1(ok1), .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h82), .ep_write(phasewordwrite), .ep_dataout(phasewordwire));
	okPipeIn clkpipe(.ok1(ok1), .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h83), .ep_write(clkwrite), .ep_dataout(clkwire));


	
	okWireOut ep20 (.ok1(ok1), .ok2(ok2x[ 4*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(finalSum));

endmodule
