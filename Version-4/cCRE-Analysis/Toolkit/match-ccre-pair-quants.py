import sys
import math
from scipy import stats
from scipy.stats import pearsonr

def Process_Quantifications(quantData):
    quantDict = {}
    next(quantData)
    for line in quantData:
        line = line.rstrip().split("\t")
        if line[2] != "NA":
            quantDict[line[0]] = float(line[2])
    return quantDict

pairArray = []
soloData = open(sys.argv[1])
soloDict = Process_Quantifications(soloData)
soloData.close()

mode = sys.argv[3]
if mode == "PCC":
    x = []
    y = []

inputData = open(sys.argv[2])
next(inputData)
for line in inputData:
    line = line.rstrip().split("\t")
    ccres = line[0].split("-")
    ccre1 = ccres[0]
    ccre2 = ccres[1]
    
    if (ccre1 in soloDict or ccre2 in soloDict):
        solo1 = "NA"
        solo2 = "NA"
        if ccre1 in soloDict:
            solo1 = soloDict[ccre1]
        if ccre2 in soloDict:
            solo2 = soloDict[ccre2]
        if solo1 != "NA" and solo2 != "NA":
            if mode == "PRINT":
                print(ccre1, "\t", solo1, "\t", ccre2, "\t", solo2, "\t", line[2], "\t", (solo1+solo2)/2)
            elif mode == "PCC":
                x.append((solo1+solo2)/2)
                y.append(float(line[2]))
inputData.close()

if mode == "PCC":
    print(pearsonr(x,y)[0])
elif mode != "PRINT":
    print("select either PRINT or PCC mode")

