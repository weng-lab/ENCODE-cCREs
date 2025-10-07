#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 15ab

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
cd $workingDir

grep -v PLS REST-cCREs.All.bed > tmp.rest
grep -v PLS ../../hg38-cCREs-Unfiltered.bed > tmp.all

python $scriptDir/Toolkit/count.py tmp.rest -1 | sort -k1,1  | awk '{if ($1 != "CA") print $0}' > tmp.rest-count
python $scriptDir/Toolkit/count.py tmp.all -1 | sort -k1,1  | awk '{if ($1 != "CA") print $0}' > tmp.all-count

paste tmp.rest-count tmp.all-count | awk '{print $1 "\t" $2 "\t" $4}' > Figure-Input-Data/Supplementary-Figure-15ab.REST-cCRE-Class.txt

rm tmp.*
