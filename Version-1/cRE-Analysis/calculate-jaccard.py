#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated June 2017

# To run:
# ./Run-Calculate-Saturation.sh N
# N= number of randomly selected datasets [1-21]
# mode = [promoter, enhancer, ctcf], if no mode is selected, inactive cREs will be used

import sys

def Compute_Jaccard(set_1, set_2):
    return len(set_1.intersection(set_2)) / float(len(set_1.union(set_2)))

def Create_Signal_Array(signal):
    signalArray=[]
    for line in signal:
        line=line.rstrip().split("\t")
        if float(line[1]) > 1.64:
            signalArray.append(line[0])
    return signalArray

signal1=open(sys.argv[1])
signal2=open(sys.argv[2])

sigArray1=Create_Signal_Array(signal1)
sigArray2=Create_Signal_Array(signal2)

print Compute_Jaccard(set(sigArray1), set(sigArray2))

signal1.close()
signal2.close()

