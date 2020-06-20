import math
from bitstring import BitArray, Bits

f = open("sine.coe", "w")

resultBits = 8
precisionBits = 12
totalEntries = 2**precisionBits
f.write("memory_initialization_radix = 2;\n")
f.write(";Created by script createsinelookup.py\n")
f.write("memory_initialization_vector = \n")

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
    f.write("{},\n".format(s.bin))
f.write(";\n")