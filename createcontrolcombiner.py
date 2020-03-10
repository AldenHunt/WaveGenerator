f = open("controlcombiner.v", "w")

totalWaves = 64
f.write("`timescale 1ns / 1ps\n")
f.write("`default_nettype none\n\n\n")
f.write("//Created by script createcontrolcombiner.py\n")
f.write("module controlcombiner(\ninput wire [15:0] signal,\ninput wire [5:0] blockaddress,\ninput wire write,\ninput wire clk,\noutput reg [{}:0] combinedout\n);\n\n".format(16*totalWaves - 1))
f.write("always @(posedge clk) begin\n    if (write) begin\n      case(blockaddress)\n")


for i in range(totalWaves):
    baseNum = 16 * i
    f.write("       {}: combinedout[{}:{}] <= signal;\n".format(i, baseNum + 15, baseNum))


f.write("       endcase\n   end\nend\nendmodule\n")