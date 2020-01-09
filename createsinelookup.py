import math
from bitstring import BitArray, Bits

f = open("sinetable.v", "w")

resultBits = 12
precisionBits = 14
totalEntries = 2**precisionBits
f.write("`timescale 1ns / 1ps\n")
f.write("`default_nettype none\n\n\n")
f.write("//Created by script createsinelookup.py\n")
f.write("module sinetable(input wire [{}:0] phase, output reg [{}:0] result);\n\n".format(precisionBits - 1, resultBits - 1))
f.write("always @(*)\n  case(phase)\n")


for i in range(totalEntries):
    truephase = (i * 360.0) 
    truephase = truephase / totalEntries
    res = math.sin(math.radians(truephase))
    res = res * (2**(resultBits - 1) * 1.0)
    intval = round(res)
    if (intval == 2**(resultBits - 1)):
        intval = intval - 1
    s = Bits(int=intval, length=resultBits)
    print("{} =  {}".format(intval, s.bin))
    f.write("   {}: result <= {}'b{};\n".format(i, resultBits, s.bin))

f.write("   endcase\nendmodule\n")