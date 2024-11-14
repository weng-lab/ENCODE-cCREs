import sys, math
from math import log

classDict1 = {"dELS":0,"CA-H3K4me3":0,"CA-CTCF":0,"CA-TF":0,"CA-only":0,"Low-DNase":0}
classDict2 = {"dELS":0,"CA-H3K4me3":0,"CA-CTCF":0,"CA-TF":0,"CA-only":0,"Low-DNase":0}
sum1 = 0
sum2 = 0


cell1 = open(sys.argv[1])
for line in cell1:
    line=line.rstrip().split("\t")
    key=line[-2]
    if key in classDict1:
        classDict1[key] += 1
    sum1 += 1
cell1.close()

cell2 = open(sys.argv[2])
for line in cell2:
    line=line.rstrip().split("\t")
    key=line[-2]
    if key in classDict2:
        classDict2[key] += 1
    sum2 += 1
cell2.close()

for entry in classDict1:
    #logFC = round(log(((classDict2[entry]+1)/sum2)/((classDict1[entry]+1)/sum1),2),2)
    #print(entry + "\t" + str(logFC))
    #print(entry + "\t" ,classDict1[entry], "\t", sum1,"\t", classDict2[entry], "\t",sum2)
    print(entry + "\t" + str(round(classDict1[entry]/sum1,4)) + "\t" + str(round(classDict2[entry]/sum2,4)))
