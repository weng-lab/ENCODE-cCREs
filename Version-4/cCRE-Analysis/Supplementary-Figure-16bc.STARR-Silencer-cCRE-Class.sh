#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 16bc

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
cd $workingDir

python $scriptDir/Toolkit/count.py STARR-Silencers.Robust.bed -1 | sort -k1,1  > tmp.rest-count
python $scriptDir/Toolkit/count.py ../../hg38-cCREs-Unfiltered.bed -1 | sort -k1,1  > tmp.all-count

paste tmp.rest-count tmp.all-count | awk '{print $1 "\t" $2 "\t" $4}' > Figure-Input-Data/Supplementary-Figure-16bc.STARR-Silencer-cCRE-Class.txt

rm tmp.*
