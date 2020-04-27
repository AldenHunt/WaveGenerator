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
	 output wire [7:0] led
    );

	//OK Host connections
	wire ti_clk;
	wire [16:0] ok2;
	wire [30:0] ok1;
	wire [5*17-1:0] ok2x;
	
	//Endpoint connections
	wire [15:0]  resetsignal, currblockreset;
	wire [15:0]  ampwire, offsetwire, phasewordwire, timewire;
	wire ampwrite, offsetwrite, phasewordwrite;
	wire switchinputs;
	wire signed [15:0]  finalSum, fifoout;
	
	
	//Other variables
	reg [5:0] currBlock;
	reg [15:0] currTime, finishedsignal, endtime;
	reg timeup, finishedloadin, resetbigblock;
	wire readout, fifoem, fifofull, fifowriteen;
	wire [1023:0] preamps, preoffsets, prephasewords;
	reg [1023:0] activeamps, activeoffsets, activephasewords;
	
	//Required values
	assign i2c_sda = 1'bz;
	assign i2c_scl = 1'bz;
	assign hi_muxsel = 1'b0;
	
	//Wire combinations
	assign led = finalSum[10:3];
	assign switchinputs = (resetsignal[0] || (finishedloadin && timeup));
	assign fifowriteen = ~timeup;
	
	two_clk_fifo outfifo(
	  .rst(switchinputs),
	  .wr_clk(clk1),
	  .rd_clk(ti_clk),
	  .din(finalSum),
	  .wr_en(timeup),
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
	
	okWireOR # (.N(5)) wireOR (ok2, ok2x);
	
	always@(posedge ti_clk) begin
		if (currblockreset[0]) begin
			currBlock <= 6'b0;
		end
		else if (phasewordwrite) currBlock <= currBlock + 1; //Once done with all three, will increment
	end
	
	always@(posedge clk1) begin
		if (resetsignal[1]) begin
			finishedloadin <= 1;
		end
		if (switchinputs) begin
			timeup <= 0;
			finishedsignal <= 0;
			finishedloadin <= 0;
			resetbigblock <= 1;
			currTime <= endtime;
			activeamps <= preamps;
			activeoffsets <= preoffsets;
			activephasewords <= prephasewords;
			endtime <= timewire;
		end else if (currTime != 0) begin
			resetbigblock <= 0;
			currTime <= currTime - 1;
		end else if (currTime == 0) begin
			resetbigblock <= 0;
			finishedsignal[0] <= !timeup;
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
		.results(finalSum)
	);

	okWireIn timeWire (.ok1(ok1), .ep_addr(8'h01), .ep_dataout(timewire));
	
	okTriggerIn nextSequenceTrigger (.ok1(ok1), .ep_addr(8'h40), .ep_clk(clk1), .ep_trigger(resetsignal));
	okTriggerIn resetCurrBlockTrigger (.ok1(ok1), .ep_addr(8'h41), .ep_clk(ti_clk), .ep_trigger(currblockreset));
	
	okTriggerOut finishedTrigger (.ok1(ok1), .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h60), .ep_clk(clk1), .ep_trigger(finishedsignal));
	
	okPipeIn amppipe(.ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(ampwrite), .ep_dataout(ampwire));
	okPipeIn offsetpipe(.ok1(ok1), .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h81), .ep_write(offsetwrite), .ep_dataout(offsetwire));
	okPipeIn phasewordpipe(.ok1(ok1), .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h82), .ep_write(phasewordwrite), .ep_dataout(phasewordwire));
	
	okPipeOut outputpipe (.ok1(ok1), .ok2(ok2x[3*17 +: 17]), .ep_addr(8'ha0), .ep_read(readout), .ep_datain(fifoout));

endmodule
