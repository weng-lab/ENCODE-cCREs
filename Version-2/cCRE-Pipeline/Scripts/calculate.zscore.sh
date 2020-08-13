import sys, numpy, scipy
from scipy import stats

F=open(sys.argv[1])
numArray=[]
totalArray=[]
for line in F:
    line=line.rstrip().split("\t")
    numArray.append(float(line[4]))
    totalArray.append([line[0],float(line[4])])

z=stats.zscore(numArray)

i=0
for entry in totalArray:
    print entry[0]+"\t"+str(z[i])+"\t"+str(entry[1])
    i+=1

F.close()
