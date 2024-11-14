import sys

def Create_PLS_Gene_Dict(plsGenes):
    plsGeneDict = {}
    for line in plsGenes:
        line = line.rstrip().split("\t")
        line[0] = line[0].rstrip()
        if line[0] not in plsGeneDict:
            plsGeneDict[line[0]] = [line[1]]
        else:
            plsGeneDict[line[0]].append(line[1])
    return plsGeneDict

def Create_PLS_Link_Dict(plsLinks):
    plsLinkDict = {}
    for line in plsLinks:
        line = line.rstrip().split("\t")
        if line[3] not in plsLinkDict:
            plsLinkDict[line[3]] = [line[7]]
        else:
            plsLinkDict[line[3]].append(line[7])
    return plsLinkDict

plsGenes = open(sys.argv[1])
plsGeneDict = Create_PLS_Gene_Dict(plsGenes)
plsGenes.close()

plsLinks = open(sys.argv[2])
plsLinkDict = Create_PLS_Link_Dict(plsLinks)
plsLinks.close()

delsLinks = open(sys.argv[3])
for line in delsLinks:
    line = line.rstrip().split("\t")
    link = line[3]
    for pls in plsLinkDict[line[3]]:
        for gene in plsGeneDict[pls]:
            print(line[7] + "\t" + pls + "\t" + link + "\t" + gene)
delsLinks.close()

