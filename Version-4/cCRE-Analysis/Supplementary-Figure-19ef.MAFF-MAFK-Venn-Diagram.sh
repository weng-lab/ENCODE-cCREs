#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 19ef

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/4_MAFF-MAFK
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
cd $workingDir

a=$(wc -l K562-MAFF-MAFK.K562.bed | awk '{print $1}')
b=$(wc -l HepG2-MAFF-MAFK.HepG2.bed | awk '{print $1}')
c=$(awk 'FNR==NR {x[$4];next} ($4 in x)' HepG2-MAFF-MAFK.HepG2.bed K562-MAFF-MAFK.K562.bed | wc -l | awk '{print $1}')

echo -e "All" "\t" $a "\t" $b "\t" $c > tmp.out

grep Low-DNase K562-MAFF-MAFK.K562.bed > tmp.1
a=$(wc -l tmp.1 | awk '{print $1}')

grep Low-DNase HepG2-MAFF-MAFK.HepG2.bed > tmp.2
b=$(wc -l tmp.2 | awk '{print $1}')
c=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

echo -e "Low-DNase" "\t" $a "\t" $b "\t" $c >> tmp.out

mv tmp.out Figure-Input-Data/Supplementary-Figure-19ef.MAFF-MAFK-cCRE-Overlap.txt
