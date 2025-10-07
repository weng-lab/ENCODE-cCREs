#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 9

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

cd $workingDir

#wget
summary=GRCh38-rDHS-Filtered-Summary.txt
list=GRCh38-Hotspot-List.txt

awk '{print $4}' $summary | awk -F "-" '{print $1}' > tmp.1
python $scriptDir/Toolkit/count.py tmp.1 0 | sort -k1,1 > tmp.counts

python $scriptDir/Toolkit/group-biosamples.py GRCh38-Hotspot-List.txt | sort -k1,1 > tmp.stage
python $scriptDir/Toolkit/assign-organ-tissue.py GRCh38-Hotspot-List.txt GRCh38  | sort -k2,2 > tmp.organ

paste tmp.organ tmp.counts | sort -k1,1 | paste - tmp.stage > tmp.summary
python $scriptDir/Toolkit/count-with-sum.py tmp.summary 9 11 > tmp.out

mv tmp.summary Table-Input-Data/Supplementary-Table-6b.rDHS-Contribution.txt
mv tmp.out Figure-Input-Data/Supplementary-Figure-9.rDHS-Contribution-Organ-Tissue.txt

rm tmp.*
