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
	wire [1*17-1:0] ok2x;
	
	//Endpoint connections
	wire [15:0]  ep00wire, ep01wire, ep02wire, ep03wire, ep04wire;
	wire [15:0]  ampwire, offsetwire, phasewordwire, clkwire;
	wire ampwrite, offsetwrite, phasewordwrite, clkwrite;
	wire [15:0]  ep20wire;
	
	
	//Other variables
	wire [15:0] finalSum;
	reg toSineClock;
	reg [15:0] loops;
	
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
	  
	always@(posedge clk1) begin
		if (ep03wire[0] == 1'b1) begin
			loops <= ep04wire;
			toSineClock <= 1'b0;
		end else if (loops == 0) begin
			loops <= ep04wire;
			toSineClock <= 1'b1;
		end else begin
			loops <= loops - 1;
			toSineClock <= 1'b0;
		end
	end
	
	singlecompute testc(
		.amp(ep00wire),
		.phaseoffset(ep01wire),
		.phaseadd(ep02wire),
		.clk(toSineClock),
		.reset(ep03wire[0]),
		.result(finalSum)
	);
	
	assign ep20wire = finalSum;
	assign led = finalSum[10:3];
	
	okWireIn ep00 (.ok1(ok1), .ep_addr(8'h00), .ep_dataout(ep00wire));
	okWireIn ep01 (.ok1(ok1), .ep_addr(8'h01), .ep_dataout(ep01wire));
	okWireIn ep02 (.ok1(ok1), .ep_addr(8'h02), .ep_dataout(ep02wire));
	okWireIn ep03 (.ok1(ok1), .ep_addr(8'h03), .ep_dataout(ep03wire));
	okWireIn ep04 (.ok1(ok1), .ep_addr(8'h04), .ep_dataout(ep04wire));
	
	okPipeIn amppipe(.ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(ampwrite), .ep_dataout(ampwire));
	okPipeIn offsetpipe(.ok1(ok1), .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h81), .ep_write(offsetwrite), .ep_dataout(offsetwire));
	okPipeIn phasewordpipe(.ok1(ok1), .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h82), .ep_write(phasewordwrite), .ep_dataout(phasewordwire));
	okPipeIn clkpipe(.ok1(ok1), .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h83), .ep_write(clkwrite), .ep_dataout(clkwire));


	
	okWireOut ep20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(ep20wire));

endmodule
