import ok
import sys
import csv
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

# Read in csv from command line and send via pipes to FPGA
MAXARG = 0xFFFF
SINEMODULES = 64
wavelist = []

#Open CSV
fileName = sys.argv[1]
with open(fileName, newline='') as sineParameters:
    reader = csv.reader(sineParameters)

    for row in reader:
        #Go through one row of values and put in pipes
        for i in range(SINEMODULES):
            amp = int(row[i])
            offset = int(row[i+SINEMODULES])
            phaseadd = int(row[i+2*SINEMODULES])  

            #Check vals within range
            if ((amp > MAXARG) | (offset > MAXARG) | (phaseadd > MAXARG)):
                sys.exit("Error at row {}, module {}: Wave arguments must be less than 0xFFFF".format(row, i))
            
            #Write to pipes
            dev.WriteToPipeIn(0x80, amp)
            dev.WriteToPipeIn(0x81, offset)
            dev.WriteToPipeIn(0x82, phaseadd)

        #Send length of time
        time = int(row[3*SINEMODULES])
        if (time > MAXARG):
            sys.exit("Error at row {}: Time argument must be less than 0xFFFF".format(row))
        dev.SetWireInValue(0x01, time)
        dev.UpdateWireIns()
        #Reset (this switches over piped-in values to be active)
        dev.SetWireInValue(0x00, 1)
        dev.UpdateWireIns()
        dev.SetWireInValue(0x00, 0)
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
  

    