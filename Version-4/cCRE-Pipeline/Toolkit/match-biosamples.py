#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024

def Process_List(data, mode, dataDict1, dataDict2):
    for line in data:
        line=line.rstrip().split("\t")
        if line[2] not in dataDict1:
            dataDict1[line[2]]=["N","N","N","N"]
            dataDict2[line[2]]=["---","---","---","---","---","---","---","---"]

        dataDict1[line[2]][mode]="Y"
        dataDict2[line[2]][mode*2]=line[0]
        dataDict2[line[2]][mode*2+1]=line[1]
    return dataDict1, dataDict2
        
groupDict={"YYYY":"Group1", "YYYN":"Group2", "YYNY":"Group3", \
           "YYNN":"Group4", "YNYN":"Group5", "YNNY":"Group6", \
           "YNNN":"Group7", "NYYN":"Group8", "NYNY":"Group9", \
           "NYNN":"Group10", "NNYN":"Group11", "NNNY":"Group12", \
           "NYYY":"Group13", "YNYY":"Group14", "NNYY":"Group15"}

dataDict1={}
dataDict2={}

dnase=open("DNase-List.txt")
dataDict=Process_List(dnase, 0, dataDict1, dataDict2)
dnase.close()

h3k4me3=open("H3K4me3-List.txt")
dataDict=Process_List(h3k4me3, 1, dataDict1, dataDict2)
h3k4me3.close()

h3k27ac=open("H3K27ac-List.txt")
dataDict=Process_List(h3k27ac, 2, dataDict1, dataDict2)
h3k27ac.close()

ctcf=open("CTCF-List.txt")
dataDict=Process_List(ctcf, 3, dataDict1, dataDict2)
ctcf.close()


for cell in dataDict1:
    annotation="".join(dataDict1[cell])
    print("\t".join(dataDict2[cell])+"\t"+cell+"\t"+groupDict[annotation])
    
    
    
    
