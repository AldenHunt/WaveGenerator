import ok
import pandas as pd
import matplotlib.pyplot as plt
dev = ok.okCFrontPanel()
dev.OpenBySerial("")
dev.LoadDefaultPLLConfiguration()
# error = dev.ConfigureFPGA("top.bit")
# if error:
#     print(error)
if dev.IsFrontPanelEnabled() == True:
     print("FrontPanel host interface enabled.")
else:
     print("FrontPanel host interface not detected.")


#data = pd.read_csv('testdata.csv')
#dev.ConfigureFPGA("tester.bit")
#for label, content in data.iterrows():
#amp = bytearray(content['amplitude'])
for x in range(3):
    wavelist = []
    amp = 0x0001
    offset = 0x0000
    phaseadd = 0x0008 * (x + 1)

    dev.SetWireInValue(0x00, amp)
    dev.SetWireInValue(0x01, offset)
    dev.SetWireInValue(0x02, phaseadd)
    dev.SetWireInValue(0x04, 2**15)
    # Reset FPGA and start accumulator
    dev.SetWireInValue(0x03, 1)
    dev.UpdateWireIns()
    dev.SetWireInValue(0x03, 0)
    dev.UpdateWireIns()
    while(True):
        dev.UpdateWireOuts()
        sVOne = dev.GetWireOutValue(0x20)
        if abs(sVOne) < 10: break
    for i in range(1600):
        dev.UpdateWireOuts()
        sineValue = dev.GetWireOutValue(0x20)
        if sineValue > 2**11 - 1:
            sineValue = sineValue - 2**12
        wavelist.append(sineValue)
    plt.plot(wavelist)
    

plt.title("FPGA-Generated Waves w/ Varying Phase Words")
plt.savefig("gensineword.png")
  

    