import sys

ccreDict = {"PLS":0, "pELS":0, "dELS":0, 
	    "CA-H3K4me3":0, "CA-CTCF":0, 
            "CA-TF":0, "CA-only":0,
            "Low-DNase":0}

inputData = open(sys.argv[1])
column = int(sys.argv[2])

for line in inputData:
    line = line.rstrip().split("\t")
    ccreDict[line[column]] += 1
inputData.close()

for group in ccreDict:
    print(group + "\t" + str(ccreDict[group]))
