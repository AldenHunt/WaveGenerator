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
	 output wire i2c_sda,
	 output wire i2c_scl,
	 output wire hi_muxsel,
	 output wire [7:0] led,
	 output wire [15:0] wave
    );
	
	//Endpoint connections
	wire [15:0]  resetsignal, currblockreset;
	wire [15:0]  ampwire, offsetwire, phasewordwire, timewire;
	wire ampwrite, offsetwrite, phasewordwrite;
	reg switchinputs;
	reg [15:0] finishedout;
	wire signed [15:0]  finalSum, fifoout;
	
	
	//Other variables
	reg [5:0] currBlock;
	reg [15:0] currTime, preTime;
	reg resetbigblock, finishedloadin, timeup, startedmachine;
	wire readout, fifoem, fifofull, activeout;
	wire [1023:0] preamps, preoffsets, prephasewords;
	reg [1023:0] activeamps, activeoffsets, activephasewords;
	
	//Required values
	assign i2c_sda = 1'bz;
	assign i2c_scl = 1'bz;
	assign hi_muxsel = 1'b0;
	
	//Wire combinations
	assign led[7:0] = finalSum[15:8];
	assign wave[15:0] = finalSum[15:0];
	
	always@(*) begin
		switchinputs = (resetsignal[0] || (finishedloadin && timeup));
	end
	
	two_clk_fifo outfifo(
	  .rst(resetsignal[2]),
	  .wr_clk(clk1),
	  .rd_clk(ti_clk),
	  .din(finalSum),
	  .wr_en(activeout),
	  .rd_en(readout),
	  .dout(fifoout),
	  .full(fifofull),
	  .empty(fifoem)
	);
	
	okHost okHI( 
		.hi_in(hi_in),
		.hi_out(hi_out),
		.hi_inout(hi_inout),
		.hi_aa(hi_aa),
		.ti_clk(ti_clk),
		.ok1(ok1),
		.ok2(ok2)
   );
	
	always@(posedge ti_clk) begin
		if (currblockreset[0]) begin
			currBlock <= 6'b0;
			preTime <= timewire;
		end
		else if (phasewordwrite) currBlock <= currBlock + 1; //Once done with all three, will increment
	end
	
	always@(posedge clk1) begin
		finishedout <= 8'h00;
		if (resetsignal[1]) begin
			finishedloadin <= 1;
		end
		if (switchinputs) begin
			startedmachine <= 1'b1;
			finishedout <= 8'h00;
			timeup <= 0;
			finishedloadin <= 0;
			resetbigblock <= 1;
			currTime <= preTime;
			activeamps <= preamps;
			activeoffsets <= preoffsets;
			activephasewords <= prephasewords;
		end else if (currTime != 0) begin
			resetbigblock <= 0;
			currTime <= currTime - 1;
		end else if (currTime == 0) begin
			resetbigblock <= 0;
			activeamps <= 0;
			activeoffsets <= 0;
			activephasewords <= 0;
			if (timeup == 0)
				finishedout <= 8'h01;
			timeup <= 1;
		end
				
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
		.reset(resetbigblock),
		.activein((!timeup & startedmachine)),
		.results(finalSum),
		.activeout(activeout)
	);
	
	//OK Host connections
	wire ti_clk;
	wire [16:0] ok2;
	wire [30:0] ok1;
	wire [9*17-1:0] ok2x;
	okWireOR # (.N(9)) wireOR (ok2, ok2x);

	okWireIn timeWire (.ok1(ok1), .ep_addr(8'h01), .ep_dataout(timewire));

	okWireOut activeampsWire(.ok1(ok1), .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h21), .ep_datain(activeamps[15:0]));
	okWireOut activeoffsetWire(.ok1(ok1), .ok2(ok2x[6*17 +: 17]), .ep_addr(8'h22), .ep_datain(activeoffsets[15:0]));
	okWireOut activepwWire(.ok1(ok1), .ok2(ok2x[7*17 +: 17]), .ep_addr(8'h23), .ep_datain(activephasewords[15:0]));
	okWireOut activetimeWire(.ok1(ok1), .ok2(ok2x[8*17 +: 17]), .ep_addr(8'h24), .ep_datain(currTime));
	
	okTriggerIn nextSequenceTrigger (.ok1(ok1), .ep_addr(8'h40), .ep_clk(clk1), .ep_trigger(resetsignal));
	okTriggerIn resetCurrBlockTrigger (.ok1(ok1), .ep_addr(8'h41), .ep_clk(ti_clk), .ep_trigger(currblockreset));

	okTriggerOut finishedTrigger(.ok1(ok1), .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h60), .ep_clk(clk1), .ep_trigger({finishedout}));
	 
	okPipeIn amppipe(.ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(ampwrite), .ep_dataout(ampwire));
	okPipeIn offsetpipe(.ok1(ok1), .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h81), .ep_write(offsetwrite), .ep_dataout(offsetwire));
	okPipeIn phasewordpipe(.ok1(ok1), .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h82), .ep_write(phasewordwrite), .ep_dataout(phasewordwire));
	
	okPipeOut outputpipe (.ok1(ok1), .ok2(ok2x[3*17 +: 17]), .ep_addr(8'ha0), .ep_read(readout), .ep_datain(fifoout));

endmodule
