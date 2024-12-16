

import sys, numpy

def Compare_Closest_Gene(closestGeneDict, classDict):
    closeCounter = 0
    for ccre in classDict:
        default = "no"
        ccreGenes = closestGeneDict[ccre]
        for gene in ccreGenes:
            if gene in classDict[ccre]:
                default = "yes"
        if default == "yes":
            closeCounter += 1
    return closeCounter

def Calculate_Median_Genes(classDict):
    geneCounts = []
    for ccre in classDict:
        numGenes = len(list(set(classDict[ccre])))
        geneCounts.append(numGenes)
    medianGenes=round(numpy.median(geneCounts),1)
    meanGenes=round(numpy.mean(geneCounts),2)
    return medianGenes, meanGenes

def Create_Closest_Gene_Dict(closestGenes):
    closestGenes = open(closestGenes)
    closestGeneDict = {}
    for line in closestGenes:
        line = line.rstrip().split("\t")
        if line[4] not in closestGeneDict:
            closestGeneDict[line[4]] = []
        closestGeneDict[line[4]].append(line[-1].split(".")[0])
    closestGenes.close()
    return closestGeneDict

def Count_cCRE_Classes(ccres):
    ccres = open(ccres)
    countDict = {}
    for line in ccres:
        line = line.rstrip().split("\t")
        if line[9] not in countDict:
            countDict[line[9]] = 0
        countDict[line[9]] += 1
    ccres.close()
    return countDict

closestPCDict = Create_Closest_Gene_Dict("tmp.closest-pc")
closestAllDict = Create_Closest_Gene_Dict("tmp.closest-all")

countDict = Count_cCRE_Classes("tmp.ccres")
classDict = {"PLS":{}, "pELS":{}, "dELS":{}, "CA-H3K4me3":{}, "CA-CTCF":{}, "CA-TF":{},"CA-only":{}}

intersections=open("tmp.intersect")
for line in intersections:
    line = line.rstrip().split("\t")

    ccreClass = line[9]
    ccreID =  line[3]
    geneID = line[17]

    if ccreID not in classDict[ccreClass]:
        classDict[ccreClass][ccreID] = []
    classDict[ccreClass][ccreID].append(geneID)

for key in classDict:
    try:
        fraction = str(round(len(classDict[key])/countDict[key],4))
        medianGenes, meanGenes = Calculate_Median_Genes(classDict[key])
        pcFraction = str(round(Compare_Closest_Gene(closestPCDict, classDict[key])/len(classDict[key]),4))
        allFraction = str(round(Compare_Closest_Gene(closestAllDict, classDict[key])/len(classDict[key]),4))
    except:
        fraction = "---"
        pcFraction = "---"
        allFraction = "---"
        medianGenes = "---"
        meanGenes = "---"
    print("\t"+ fraction +"\t"+ str(medianGenes) +"\t"+ str(meanGenes) +"\t"+ pcFraction +"\t"+ allFraction, end='')

print("")
    



    

