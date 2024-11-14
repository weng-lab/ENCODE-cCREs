

from scipy.stats import fisher_exact
from scipy.stats import false_discovery_control
import numpy
import sys

testA = []
testB = []
testC = []
testD = []
runningLines = []

for line in open(sys.argv[1]):
    line = line.rstrip().split("\t")
    silencer1 = int(line[3])
    totalSilencer1 = int(line[4])
    silencer2 = int(line[5])
    totalSilencer2 = int(line[6])

    control1 = int(line[7])
    totalControl1 = int(line[8])
    control2 = int(line[9])
    totalControl2 = int(line[10])

    testA.append(fisher_exact([[silencer1, totalSilencer1-silencer1],[control1,totalControl1-control1]], alternative='two-sided')[1])
    testB.append(fisher_exact([[silencer1, totalSilencer1-silencer1],[control2,totalControl2-control2]], alternative='two-sided')[1])
    testC.append(fisher_exact([[silencer2, totalSilencer2-silencer2],[control1,totalControl1-control1]], alternative='two-sided')[1])
    testD.append(fisher_exact([[silencer2, totalSilencer2-silencer2],[control2,totalControl2-control2]], alternative='two-sided')[1])
    runningLines.append(line)



fdrA = false_discovery_control(numpy.array(testA))
fdrB = false_discovery_control(numpy.array(testB))
fdrC = false_discovery_control(numpy.array(testC))
fdrD = false_discovery_control(numpy.array(testD))

i=0
for line in runningLines:
    print("\t".join(line) + "\t" + str(testA[i]) +"\t" + str(fdrA[i]) + \
    "\t" + str(testB[i]) +"\t" + str(fdrB[i]) + "\t" + str(testC[i]) + \
    "\t" + str(fdrC[i]) + "\t" + str(testD[i]) +"\t" + str(fdrD[i]) )
    i += 1


