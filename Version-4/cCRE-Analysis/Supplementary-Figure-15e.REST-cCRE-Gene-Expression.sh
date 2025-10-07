#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 15e

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
cd $workingDir

wget https://www.encodeproject.org/files/ENCFF421TJX/@@download/ENCFF421TJX.tsv
rnaExp=ENCFF421TJX.tsv
tss=~/Lab/Reference/Human/hg38/GENCODE40/TSS.Basic-PC.bed

rm -f tmp.results
classes=(PLS pELS dELS CA-CTCF CA-H3K4me3 CA-TF TF)
for class in ${classes[@]}
do
    echo $class
    awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed > tmp.cCREs
    sort -k1,1 -k2,2n tmp.cCREs | bedtools closest -a stdin -b $tss | \
        awk '{print $NF}' | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' - $rnaExp | \
        awk '{print $1 "\t" $6 "\t" "'$class'"}' >> tmp.results
done

groups=(K562-PLS K562-pELS K562-dELS K562-Inactive REST-Silencers
        REST-Enhancers)
for group in ${groups[@]}
do
    echo $group
    sort -k1,1 -k2,2n $group.bed | bedtools closest -a stdin -b $tss | \
        awk '{print $NF}' | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' - $rnaExp | \
        awk '{print $1 "\t" $6 "\t" "'$group'"}' >> tmp.results
done

mv tmp.results Figure-Input-Data/Supplementary-Figure-15e.REST-Silencer-Gene-Expression.txt
rm tmp* ENCFF421TJX.tsv
