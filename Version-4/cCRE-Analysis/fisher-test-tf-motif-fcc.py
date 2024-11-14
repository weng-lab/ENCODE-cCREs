

from scipy.stats import fisher_exact
from scipy.stats import false_discovery_control
import numpy
import sys

testA = []
runningLines = []

for line in open(sys.argv[1]):
    line = line.rstrip().split("\t")
    group1 = int(line[1])
    totalGroup1 = int(line[2])
    group2 = int(line[3])
    totalGroup2 = int(line[4])

    testA.append(fisher_exact([[group1, totalGroup1-group1],[group2, totalGroup2-group2]], alternative='two-sided')[1])
    runningLines.append(line)

fdrA = false_discovery_control(numpy.array(testA))

i=0
for line in runningLines:
    print("\t".join(line) + "\t" + str(testA[i]) +"\t" + str(fdrA[i]))
    i += 1


