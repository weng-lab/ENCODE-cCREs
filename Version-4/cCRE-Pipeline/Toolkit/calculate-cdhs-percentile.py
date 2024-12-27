#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

import sys, numpy

def Create_Sig_Array(rDHSs):
    sigArray = []
    rDHSs = open(rDHSs)
    for line in rDHSs:
        line = line.rstrip().split("\t")
        sigArray.append(float(line[5]))
    rDHSs.close()
    return numpy.array(sigArray)


rDHSs = sys.argv[1]
sigArray = Create_Sig_Array(rDHSs)

#print numpy.percentile(sigArray, 0.5)

for i in range(1,100,1):
    print(str(i)+"\t"+str(numpy.percentile(sigArray,i)))
