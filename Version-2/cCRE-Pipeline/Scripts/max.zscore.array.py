import sys

matrix=open(sys.argv[1])

for line in matrix:
    line=line.rstrip().split("\t")
    rDHS=line[0]
    ZscoreArray=[float(i) for i in line[1:]]
    print rDHS+"\t"+str(max(ZscoreArray))

matrix.close()
