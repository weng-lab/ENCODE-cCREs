import sys

def Process_Signal(sigs):
    sigDict={}
    for line in sigs:
        line=line.rstrip().split("\t")
        sigDict[line[0]]=[float(line[1]),float(line[2]),int(line[3])]
    sigs.close()
    return sigDict

regionDict={}

dnaseSig=open(sys.argv[1])
dnaseDict=Process_Signal(dnaseSig)
dnaseSig.close()
h3k27acSig=open(sys.argv[2])
h3k27acDict=Process_Signal(h3k27acSig)
h3k27acSig.close()
aveRank=open(sys.argv[3])
arDict=Process_Signal(aveRank)
aveRank.close()

overlaps=open(sys.argv[4])
for line in overlaps:
    line=line.rstrip().split("\t")
    region=line[3]
    rdhs=line[7]
    if rdhs not in dnaseDict:
        pass
    else: 
        if region not in regionDict:
            regionDict[region]=[dnaseDict[rdhs],h3k27acDict[rdhs],arDict[rdhs]]
        if dnaseDict[rdhs][0] > regionDict[region][0][0]:
            regionDict[region][0]=dnaseDict[rdhs]
        if h3k27acDict[rdhs][0] > regionDict[region][1][0]:
            regionDict[region][1]=h3k27acDict[rdhs]
        if arDict[rdhs][2] < regionDict[region][2][2]:
            regionDict[region][2]=arDict[rdhs]
    
overlaps.close()

masterDict={}
master=open(sys.argv[5])
for line in master:
    line=line.rstrip().split("\t")
    masterDict[line[0]]=line[2].split()[0]
master.close()

for region in regionDict:
    print region+"\t"+masterDict[region]+"\t"+"\t".join([str(i) for i in regionDict[region][0]])+"\t"+ \
        "\t".join([str(i) for i in regionDict[region][1]])+"\t"+"\t".join([str(i) for i in regionDict[region][2]])
