import numpy, sys, math

sig=[[],[]]
masterPeak=[]
calculate=[]
bigWig=open(sys.argv[1])

for line in open(sys.argv[1]):
    line=line.rstrip().split("\t")
    if float(line[4]) == 0:
	sig[1].append("Zero")
	sig[0].append((float(line[4])))
	masterPeak.append(line[0])
    else:
    	sig[1].append(math.log(float(line[4]),10))
	sig[0].append((float(line[4])))
	calculate.append(math.log(float(line[4]),10))
	masterPeak.append(line[0])

lmean=numpy.mean(calculate)
lstd=numpy.std(calculate)
i=0
for entry in sig[1]:
    if entry != "Zero":
	print masterPeak[i], "\t", (entry-lmean)/lstd, "\t", sig[0][i], "\t", sig[1][i]
    else:
	print masterPeak[i], "\t", -10, "\t", 0, "\t", 0
    i+=1
bigWig.close()
