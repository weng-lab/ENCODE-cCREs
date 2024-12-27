#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

import sys

def Set_IDs(genome, mode):
    genomeDict = {"hg19":"EH37","hg38":"EH38","mm10":"EM10"}
    modeDict = {"rDHS":"D","ccRE":"E", "cCRE":"E", "TF":"F"}
    genomeID = ""
    modeID = ""
    try:
        genomeID = genomeDict[genome]
    except:
        print("\nERROR! Please enter valid genome [hg19, hg38, mm10]\n")
    try:
        modeID = modeDict[mode]
    except:
        print("\nERROR! Please enter valid mode [rDHS, cRE]\n")
    return genomeID, modeID

def Process_Previous(previousRegions, modeID):
    previousDict = {}
    maxAccession = 0
    for line in previousRegions:
        line = line.rstrip().split("\t")
        previousDict[line[0]+line[1]+line[2]] = line[3]
        number = int(line[3].split(modeID)[-1])
        if number > maxAccession:
            maxAccession = number
    return previousDict, maxAccession

def Process_LiftOver(liftRegions):
    liftDict = {}
    for line in liftRegions:
        line = line.rstrip().split("\t")
        liftDict[line[3]] = line[0]+line[1]+line[2]
    return liftDict
    
genome = sys.argv[2]
mode = sys.argv[3]

genomeID, modeID = Set_IDs(genome, mode)

if len(sys.argv) > 4:
    previousRegions = open(sys.argv[4])
    previousDict, maxAccession = Process_Previous(previousRegions, modeID)
    previousRegions.close()
else:
    previousDict = {}
    maxAccession = 0

regions = open(sys.argv[1])

i = maxAccession+1

if genomeID != "" and modeID != "":
    for line in regions:
        line = line.rstrip().split("\t")
        coords = line[0]+line[1]+line[2]
        if coords in previousDict:
            accession = previousDict[coords].replace("EH37","EH38")
        else:
            accession = genomeID+modeID+str(i).zfill(7)
            i += 1
        if mode == "cCRE" or mode == "ccRE":
            print(line[0]+"\t"+line[1]+"\t"+line[2]+"\t"+line[3]+"\t"+accession+"\t"+line[4])
        elif mode == "rDHS" or mode == "TF":
            print("\t".join(line)+"\t"+accession)
        
regions.close()
