#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

import sys
merge = open(sys.argv[1])
for line in merge:
    line = line.rstrip().split("\t")
    signal = [float(i) for i in line[4].split(",")]
    peaks = line[3].split(",")
    print(peaks[signal.index(max(signal))])
merge.close() 
    
