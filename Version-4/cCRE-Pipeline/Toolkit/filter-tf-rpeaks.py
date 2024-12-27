#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

import sys

peakDict = {}
peaks = open (sys.argv[1])

for line in peaks:
    line = line.rstrip().split("\t")
    if line[13] not in peakDict:
        peakDict[line[13]] = [line[0], line[1], line[2], line[9], \
                              [line[-4]], [line[-3]], [line[-5]]]
    else:
        peakDict[line[13]][4].append(line[-4])
        peakDict[line[13]][5].append(line[-3])
        peakDict[line[13]][6].append(line[-5])

for peak in peakDict:
    experiments = list(set(peakDict[peak][6]))
    coords = peakDict[peak][0] + "\t" + peakDict[peak][1] + "\t" + \
             peakDict[peak][2] + "\t" + peak
    cells = list(set(peakDict[peak][5]))
#    status = "FAIL"
#    for cell in cells:
#        if "genetically modified" not in cell:
#            status = "PASS"
    if len(experiments) >= 5:# and status == "PASS":
        tfs = ";".join(list(set(peakDict[peak][4])))
        cells = ";".join(cells)
        exps = ";".join(experiments)
        print(coords + "\t" + tfs + "\t" + cells + "\t" + exps + "\t" + str(len(experiments)))
