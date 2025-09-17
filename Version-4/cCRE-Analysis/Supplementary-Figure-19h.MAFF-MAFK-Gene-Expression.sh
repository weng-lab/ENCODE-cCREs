#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 19h

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/4_MAFF-MAFK
ccresK562=../../Cell-Type-Specific/Individual-Files/ENCFF414OGC_ENCFF806YEZ_ENCFF849TDM_ENCFF736UDR.bed
cd $workingDir

grep Low-DNase $ccresK562 | bedtools intersect -v -a stdin -b K562-MAFF-MAFK.Agnostic.bed > K562.Low-DNase-No-MAF.bed

wget https://www.encodeproject.org/files/ENCFF421TJX/@@download/ENCFF421TJX.tsv
rnaExp=ENCFF421TJX.tsv
tss=~/Lab/Reference/Human/hg38/GENCODE40/TSS.Basic-PC.bed

rm -f tmp.results

groups=(MAFF-MAFK.Common-Low-DNase K562.Low-DNase-No-MAF)
for group in ${groups[@]}
do
    echo $group
    sort -k1,1 -k2,2n $group.bed | bedtools closest -a stdin -b $tss | \
        awk '{print $NF}' | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' - $rnaExp | \
        awk '{print $1 "\t" $6 "\t" "'$group'"}' >> tmp.results
done

mv tmp.results Figure-Input-Data/Supplementary-Figure-19h.MAFF-MAFK-Gene-Expression.txt
rm tmp* ENCFF421TJX.tsv
