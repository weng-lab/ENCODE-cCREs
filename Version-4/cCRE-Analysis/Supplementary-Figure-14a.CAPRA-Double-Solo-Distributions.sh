#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 14a

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

soloQuant=CAPRA-Output/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
doubleQuant=CAPRA-Output/ENCSR661FOW-DESeq2.Double-Pair.V7.txt

cd $workingDir

awk '{if (NR > 1) print "Solo" "\t" $3}' $soloQuant > Figure-Input-Data/Supplementary-Figure-14a.CAPRA-Solo-Double-Distribution.txt
awk '{if (NR > 1) print "Double" "\t" $3}' $doubleQuant >> Figure-Input-Data/Supplementary-Figure-14a.CAPRA-Solo-Double-Distribution.txt
