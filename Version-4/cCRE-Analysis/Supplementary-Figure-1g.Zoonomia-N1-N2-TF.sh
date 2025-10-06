
#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 1g

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

#wget
#gunzip
data=Zoonomia-N1-N2-TF-Anchors.bed

for j in `seq 1 1 19`
do
    echo $j
    awk '{if ($(NF-2) == '$j') print $0}' $data > tmp
    awk '{if ($(NF-1) <=5 && $NF >= 235) sum +=1; all +=1}END{print "'$j'" "\t" sum/all}' tmp >> tmp.summary
done
awk '{if ($(NF-2) >= 20) print $0}' $data > tmp
awk '{if ($(NF-1) <=5 && $NF >= 235) sum +=1; all +=1}END{print "20+" "\t" sum/all}' tmp >> tmp.summary

mv tmp.summary Figure-Input-Data/Supplementary-Figure-1g.Zoonomia-N1-N2-TF.txt
rm tmp.*
