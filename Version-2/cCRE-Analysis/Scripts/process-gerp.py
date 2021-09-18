import sys, numpy

def Create_DNase_maxZ_Dict(dnase):
    dnaseDict={}
    for line in dnase:
        line=line.rstrip().split("\t")
        dnaseDict[line[0]]=float(line[1])
    return dnaseDict

def Create_Overlap_Dict(overlaps):
    overlapDict={}
    for line in overlaps:
        line=line.rstrip().split("\t")
        if line[3] not in overlapDict:
            overlapDict[line[3]]=[int(line[2])-int(line[1]),int(line[-1])]
        else:
            overlapDict[line[3]][1] += int(line[-1])
    return overlapDict

dnase=open(sys.argv[1])
dnaseDict=Create_DNase_maxZ_Dict(dnase)
dnase.close()

overlaps=open(sys.argv[2])
overlapDict=Create_Overlap_Dict(overlaps)
overlaps.close()

totalBP={"PLS":numpy.zeros(45), "pELS":numpy.zeros(45), "dELS":numpy.zeros(45),\
         "CTCF-only":numpy.zeros(45), "DNase-H3K4me3":numpy.zeros(45)}
conservBP={"PLS":numpy.zeros(45), "pELS":numpy.zeros(45), "dELS":numpy.zeros(45),\
         "CTCF-only":numpy.zeros(45), "DNase-H3K4me3":numpy.zeros(45)}
totalEl={"PLS":numpy.zeros(45), "pELS":numpy.zeros(45), "dELS":numpy.zeros(45),\
         "CTCF-only":numpy.zeros(45), "DNase-H3K4me3":numpy.zeros(45)}

ccres=open(sys.argv[3])
for line in ccres:
    line=line.rstrip().split("\t")
    group=line[-1].split(",")[0]
    i=int((dnaseDict[line[3]]-1.6)*10)
    if i > 44:
        i=44
    if line[3] in overlapDict:
        totalBP[group][i]+=overlapDict[line[3]][0]
        conservBP[group][i]+=overlapDict[line[3]][1]
    else:
        totalBP[group][i]+=(int(line[2])-int(line[1]))
    totalEl[group][i]+=1
ccres.close()

print "group","\t", "cutoff","\t","percent","\t","size"
for group in totalBP:
    q=1.6
    j=0
    for k in totalEl[group]:
        print group,"\t",q,"\t", conservBP[group][j]/totalBP[group][j], "\t", k
        q+=0.1
        j+=1

#print totalBP["PLS"], conservBP["PLS"], totalEl["PLS"]



