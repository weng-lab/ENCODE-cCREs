import sys
from scipy.stats import fisher_exact

tissueDict = {}
total1 = 0
total2 = 0


restGroup = open(sys.argv[1])
for line in restGroup:
    line = line.rstrip().split("\t")
    tissues = line[5].split(", ")
    for tissue in tissues:
        tissue = tissue.split("[")[0].lstrip()
        if tissue not in tissueDict:
            tissueDict[tissue] = [0, 0]
        tissueDict[tissue][0] += 1
    total1 += 1
restGroup.close()

otherGroup = open(sys.argv[2])
for line in otherGroup:
    line = line.rstrip().split("\t")
    tissues = line[5].split(", ")
    for tissue in tissues:
        tissue = tissue.split("[")[0].lstrip()
        if tissue not in tissueDict:
            tissueDict[tissue] = [0, 0]
        tissueDict[tissue][1] += 1
    total2 += 1
otherGroup.close()

for key in tissueDict:
    values = [[tissueDict[key][0], total1-tissueDict[key][0]],[tissueDict[key][1], total2-tissueDict[key][1]]]
    print(key+"\t"+str(round(tissueDict[key][0]/total1,4))+"\t"+str(round(tissueDict[key][1]/total2,4))+"\t"+str(fisher_exact(values)[1]))
