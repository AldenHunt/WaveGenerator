import ok
import pandas as pd
dev = ok.okCFrontPanel()
dev.OpenBySerial("1810000LHX")

data = pd.read_csv('testdata.csv')

for label, content in data.iterrows():
    dataout = bytearray(content['amplitude'])
    print(dataout)
    dev.WriteToPipeIn(0x80, dataout)
    

    