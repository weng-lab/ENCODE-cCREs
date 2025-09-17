#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 19g

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/4_MAFF-MAFK
quants=../2_Functional-Characterization/CAPRA-Output/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
maf=MAFF-MAFK.Common-Low-DNase.bed

cd $workingDir

rm -f tmp.results
awk 'FNR==NR {x[$4];next} ($1 in x)' $maf $quants | \
    awk '{print $1 "\t" $3 "\t" "MAFF-MAFK"}' >> tmp.results

awk 'FNR==NR {x[$4];next} !($1 in x)' $maf $quants | \
    awk '{print $1 "\t" $3 "\t" "Background"}' | sort -R | head -n 100000 >> tmp.results

mv tmp.results Figure-Input-Data/Supplementary-Figure-19g.MAFF-MAFK-STARR-Scores.txt
