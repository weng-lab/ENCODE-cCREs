#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated June 2017

import sys

colorDict={"Promoter-like":"255,0,0", "Enhancer-like":"255,205,0", \
           "CTCF-only":"0,176,240"}

cres=open(sys.argv[1])
genome=sys.argv[2]

output1=open(genome+"-cREs-Simple.bed", "w+")
output2=open(genome+"-cREs.bed", "w+")

if genome == "mm10":
        start="EM10E"
elif genome == "hg19":
        start="EH37E"
elif genome == "hg38":
        start="EH38E"
else:
        start="EE"
        
i=1
for line in cres:
        line=line.rstrip().split("\t")
        cre=start +str(i).zfill(7)
        print >> output1, line[0]+"\t"+line[1]+"\t"+line[2]+"\t"+line[3]+"\t" \
                          +cre+"\t"+line[4]
        print >> output2, line[0]+"\t"+line[1]+"\t"+line[2]+"\t"+cre +"\t" \
                          "0\t.\t"+line[1]+"\t"+line[2]+"\t"+colorDict[line[4]]
        i+=1

cres.close()
output1.close()
output2.close()
