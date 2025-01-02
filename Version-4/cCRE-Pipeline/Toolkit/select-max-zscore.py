#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

import sys

regionDict={}

dataFile = open(sys.argv[1])
for line in dataFile:
    line = line.rstrip().split("\t")
    regionDict[line[0]] = float(line[1])
dataFile.close()

for i in range(2, len(sys.argv)):
    dataFile = open(sys.argv[i])
    for line in dataFile:
        line = line.rstrip().split("\t")
        if float(line[1]) > regionDict[line[0]]:
            regionDict[line[0]] = float(line[1])
    dataFile.close()

for entry in regionDict:
    print(entry+"\t"+str(regionDict[entry]))
