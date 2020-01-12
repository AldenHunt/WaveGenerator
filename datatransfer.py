import ok
import sys
import pandas as pd
import matplotlib.pyplot as plt
dev = ok.okCFrontPanel()
dev.OpenBySerial("")
dev.LoadDefaultPLLConfiguration()
error = dev.ConfigureFPGA("top.bit")
if error:
    print(error)
if dev.IsFrontPanelEnabled() == True:
    print("FrontPanel host interface enabled.")
else:
    print("FrontPanel host interface not detected.")

# Read in wave attributes from command line
maxArg = 0xFFFF
wavelist = []
amp = int(sys.argv[1], 16)
offset = int(sys.argv[2], 16)
phaseadd = int(sys.argv[3], 16)
freqdivider = int(sys.argv[4], 16)
if ((amp > maxArg) | (offset > maxArg) | (phaseadd > maxArg) | (freqdivider > maxArg)):
    sys.exit("Error: Wave arguments must be less than 0xFFFF")

dev.SetWireInValue(0x00, amp)
dev.SetWireInValue(0x01, offset)
dev.SetWireInValue(0x02, phaseadd)
dev.SetWireInValue(0x04, freqdivider)
# Reset FPGA and start accumulator
dev.SetWireInValue(0x03, 1)
dev.UpdateWireIns()
dev.SetWireInValue(0x03, 0)
dev.UpdateWireIns()
while(True):
    dev.UpdateWireOuts()
    sVOne = dev.GetWireOutValue(0x20)
    if abs(sVOne) < 10: break
for i in range(2000):
    dev.UpdateWireOuts()
    sineValue = dev.GetWireOutValue(0x20)
    if sineValue >= 0x1000:
        sineValue = sineValue - 2**16
    divSine = float(sineValue) / float(2**10)
    wavelist.append(divSine)
plt.plot(wavelist)
    

plt.title("FPGA-Generated Wave")
plt.savefig("gensine.png")
  

    