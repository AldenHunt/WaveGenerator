import ok
import sys
import csv
import matplotlib.pyplot as plt
import time

MAXARG = 0xFFFF
SINEMODULES = 64
wavelist = []

#Endpoints:
# 0x01: time input wire
# 0x40: reset/state triggerIn (0:startup 1:after load new row of values 2:reset currBlock to 0)
# 0x41: resetcurrBlock triggerIn (0:reset currBlock to 0)
# 0x60: timeup triggerOut (0: completed one configuration of waveforms)
# 0x80: amp input pipe
# 0x81: offset input pipe
# 0x82: phaseadd input pipe
# 0xA0: waveform output pipe

#Take one row and send it to FPGA in appropriate pipes
def sendRowToFPGA(row, dev):
    dev.ActivateTriggerIn(0x41, 0)
    for i in range(SINEMODULES):
        amp = int(row[i])
        offset = int(row[i+SINEMODULES])
        phaseadd = int(row[i+2*SINEMODULES])  

        #Check vals within range
        if ((amp > MAXARG) | (offset > MAXARG) | (phaseadd > MAXARG)):
            sys.exit("Error at row {}, module {}: Wave arguments must be less than 0xFFFF".format(row, i))
        
        ampbytes = bytearray(amp.to_bytes(2, byteorder='little'))
        offsetbytes = bytearray(offset.to_bytes(2, byteorder='little'))
        phaseaddbytes = bytearray(phaseadd.to_bytes(2, byteorder='little'))

        #Write to pipes
        dev.WriteToPipeIn(0x80, ampbytes)
        dev.WriteToPipeIn(0x81, offsetbytes)
        dev.WriteToPipeIn(0x82, phaseaddbytes)

    #Send length of time
    time = int(row[3*SINEMODULES])
    if (time > MAXARG):
        sys.exit("Error at row {}: Time argument must be less than 0xFFFF".format(row))
    dev.SetWireInValue(0x01, time)
    dev.UpdateWireIns()
    return time

#Read a certain number of values from the FPGA (usually equivalent to a multiple of the timestep provided)
def readOut(num, dev):
    while(True):
        dev.UpdateTriggerOuts()
        if (dev.IsTriggered(0x60, 0x01) == True):
            break
    dev.ActivateTriggerIn(0x40, 0x01)
    buf = bytearray(2*num)
    dev.ReadFromPipeOut(0xA0, buf)
    for i in range(num):
        val = int.from_bytes(buf[2*i:2*i+1], byteorder='little', signed=True)
        wavelist.append(val)

#Main func
def main():
    dev = ok.okCFrontPanel()
    dev.OpenBySerial("")
    dev.LoadDefaultPLLConfiguration()
    error = dev.ConfigureFPGA("top.bit")
    print(error)
    if dev.IsFrontPanelEnabled() == True:
        print("FrontPanel host interface enabled.")
    else:
        print("FrontPanel host interface not detected.")

    

    #Open CSV
    fileName = sys.argv[1]
    with open(fileName, newline='') as sineParameters:
        reader = csv.reader(sineParameters)
        
        next(reader) #Discard first line (headers)
        firstinputs = next(reader)
        dev.ActivateTriggerIn(0x41, 0)
        lastTime = sendRowToFPGA(firstinputs, dev)
        dev.ActivateTriggerIn(0x40, 0)
        print("Sent one row of inputs in and triggered")
        
        #Test whether amplitudes got to active section
        dev.UpdateWireOuts()
        activeamp = dev.GetWireOutValue(0x21)
        off = dev.GetWireOutValue(0x22)
        pw = dev.GetWireOutValue(0x23)
        time = dev.GetWireOutValue(0x24)
        print(activeamp)
        print(off)
        print(pw)
        print(time)

        for row in reader:
            #Go through one row of values and put in pipes
            print("Looping row send {}".format(reader.line_num))

            #Check if already done with last seq
            newerTime = sendRowToFPGA(row, dev)

            #Wait until last seq done, then read recently completed values and add to array
            readOut(lastTime, dev)
            dev.UpdateWireOuts()
            activeamp = dev.GetWireOutValue(0x21)
            off = dev.GetWireOutValue(0x22)
            pw = dev.GetWireOutValue(0x23)
            time = dev.GetWireOutValue(0x24)
            print(activeamp)
            print(off)
            print(pw)
            print(time)
            lastTime = newerTime

        #When no more rows from csv to send to FPGA, do one last read
        readOut(lastTime, dev)

        #Final plot
        print(wavelist)
        plt.plot(wavelist)
        plt.title("FPGA-Generated Wave")
        plt.savefig("FPGAwave.png")

if __name__ == "__main__":
    main()









  

    