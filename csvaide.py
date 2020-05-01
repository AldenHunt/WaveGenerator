import csv

##################################
# YOUR DESIRED FILENAME AND ROWS OF VALUES GO HERE
fileName = 'squarewave32.csv'
rows = 1
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
            if (j < 32):
                ampVal = int(32000.0/(2*j + 1)) #YOUR FORMULAS FOR AMP, OFFSET, PHASEWORD GO HERE
                offsetVal = 0
                pwVal = 20 * (2*j + 1)
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
            



