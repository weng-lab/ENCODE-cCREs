#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 8ab

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/VAE
cd $workingDir

#wget
gc=hg38-cCREs-Unfiltered_monoCG-diCG-NormalizedCG.bed 

#wget
counts=hg38-DNase-Biosample-Count.txt

awk 'FNR==NR {x[$4];next} ($1 in x)' $gc $counts | sort -k1,1 > tmp.2
awk 'FNR==NR {x[$1];next} ($4 in x)' $counts $gc | sort -k4,4 > tmp.1

paste tmp.1 tmp.2 > tmp.3

#wget
ccres=../../../Cell-Type-Specific/Individual-Files/ENCFF414OGC_ENCFF806YEZ_ENCFF849TDM_ENCFF736UDR.bed

grep PLS $ccres | awk 'FNR==NR {x[$4];next} ($5 in x)' - tmp.3 > tmp.4
grep dELS $ccres | awk 'FNR==NR {x[$4];next} ($5 in x)' - tmp.3 >> tmp.4

mv tmp.4 ../Figure-Input-Data/Supplementary-Figure-8ab.DNase-Count-GC.txt
rm tmp.*
