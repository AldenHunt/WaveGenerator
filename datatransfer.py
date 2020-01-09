import ok
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


#data = pd.read_csv('testdata.csv')
#dev.ConfigureFPGA("tester.bit")
#for label, content in data.iterrows():
#amp = bytearray(content['amplitude'])
amp = 0x0001
offset = 0x0000
phaseadd = 0x0001

dev.SetWireInValue(0x00, amp)
dev.SetWireInValue(0x01, offset)
dev.SetWireInValue(0x02, phaseadd)
dev.SetWireInValue(0x04, 2**12)
# Reset FPGA and start accumulator
dev.SetWireInValue(0x03, 1)
dev.UpdateWireIns()
dev.SetWireInValue(0x03, 0)
dev.UpdateWireIns()

wavelist = []
for i in range(100):
    dev.UpdateWireOuts()
    sineValue = dev.GetWireOutValue(0x20)
    print(sineValue)
    wavelist.append(sineValue)
    
plt.plot(wavelist)
plt.title("FPGA-Generated Sine Wave")
plt.savefig("gensine.png")
  

    