#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

import sys

mode=sys.argv[2]

if mode == "specific":
    ccreDict={}
    f=open(sys.argv[1])
    for line in f:
        line=line.rstrip().split("\t")
        peak=(int(line[1])+int(line[2]))/2
        tss=int(line[7])
        if line[11] == "-":
            diff=peak-tss
        elif line[11] == "+":
            diff=tss-peak
        if line[3] not in ccreDict:
            ccreDict[line[3]]=diff
        elif line[3] not in ccreDict and abs(diff) < ccreDict[line[3]]:
            ccreDict[line[3]]=diff

elif mode == "agnostic":
    ccreDict={}
    f=open(sys.argv[1])
    for line in f:
        line=line.rstrip().split("\t")
        peak=(int(line[1])+int(line[2]))/2
        tss=int(line[5])
        if line[9] == "-":
            diff=peak-tss
        elif line[9] == "+":
            diff=tss-peak
        if line[3] not in ccreDict:
            ccreDict[line[3]]=diff
        elif line[3] not in ccreDict and abs(diff) < ccreDict[line[3]]:
            ccreDict[line[3]]=diff

elif mode == "assignment":
    ccreDict={}
    f=open(sys.argv[1])
    for line in f:
        line=line.rstrip().split("\t")
        peak=(int(line[1])+int(line[2]))/2
        tss=int(line[7])
        if line[11] == "-":
            diff=peak-tss
        elif line[11] == "+":
            diff=tss-peak
        if abs(diff) < 200:
            print(line[4] + "\t" + line[-2])

elif mode == "multimap":
    ccreDict={}
    f=open(sys.argv[1])
    for line in f:
        line=line.rstrip().split("\t")
        peak=(int(line[1])+int(line[2]))/2
        tss=int(line[7])
        if line[10] == "-":
            diff=peak-tss
        elif line[10] == "+":
            diff=tss-peak
        if abs(diff) < 200:
            print(line[3] + "\t" + line[-2])


if mode != "assignment":
    for entry in ccreDict:
        print(entry, "\t", ccreDict[entry])


f.close()
