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

for entry in ccreDict:
    print entry, "\t", ccreDict[entry]


f.close()
