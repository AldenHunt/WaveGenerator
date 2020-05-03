import csv
import math

##################################
# YOUR DESIRED FILENAME AND ROWS OF VALUES GO HERE
fileName = 'offsetdemo.csv'
rows = 3
##################################

with open(fileName, mode='w') as newFile:
    fileWriter = csv.writer(newFile, lineterminator="\n")

    amp, offset, pw = [], [], []
    for i in range(64):
        amp.append("amp{}".format(i))
        offset.append("offset{}".format(i))
        pw.append("pw{}".format(i))
    headers = amp + offset + pw
    headers.append("time")
    fileWriter.writerow(headers)

    for i in range(rows):
        amp.clear()
        offset.clear()
        pw.clear()
        for j in range(64):
            if (j < 64):
                ampVal = 10000   #YOUR FORMULAS FOR AMP, OFFSET, PHASEWORD GO HERE
                offsetVal = 15000 * (1 + i)
                pwVal = 40
                amp.append(ampVal)
                offset.append(offsetVal)
                pw.append(pwVal)
            else:
                amp.append(0)
                offset.append(0)
                pw.append(0)
        newrow = amp + offset + pw
        time = 5000 #YOUR TIME FORMULA GOES HERE
        newrow.append(time)
        fileWriter.writerow(newrow)
            



