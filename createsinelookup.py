import math

f = open("sinetable.v", "w")

resultBits = 12
precisionBits = 16
totalEntries = 2**precisionBits
f.write("`timescale 1ns / 1ps\n")
f.write("`default_nettype none\n\n\n")
f.write("//Created by script createsinelookup.py\n")
f.write("module sinetable(input wire [{}:0] phase, output reg [{}:0] result);\n\n".format(precisionBits - 1, resultBits - 1))
f.write("always @(*)\n  case(phase)\n")

for i in range(totalEntries):
    truephase = (i * 2 * math.pi) / (totalEntries)
    val = math.sin(truephase)
    val = val * (2**(resultBits - 1))
    val = int(val)
    sigbits = val.bit_length()
    addbits = resultBits - sigbits
    s = format(val, 'b')       # binary representation:  bin(-37) --> '-0b100101'
    s = s.lstrip('-')
    if val < 0:
        s = (addbits * "1") + s
    elif val > 0:
        s = (addbits * "0") + s
    else:
        s = (resultBits * "0")
    f.write("   {}: result <= {}'b{};\n".format(i, resultBits, s))

f.write("   endcase\nendmodule\n")