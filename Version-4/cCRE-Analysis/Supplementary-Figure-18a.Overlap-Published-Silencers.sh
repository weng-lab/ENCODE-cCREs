#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 18a

scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers

silencers=(REST-Enhancers REST-Silencers STARR-Silencers.Stringent STARR-Silencers.Robust Cai-Fullwood-2021 Huan-Ovcharenko-2019 Jayavelu-Hawkins-2020 Pang-Snyder-2020)

cd $workingDir

#wget /path/to/download

echo "group" > tmp.matrix
for silencer1 in ${silencers[@]}
do
    echo $silencer1 >> tmp.matrix
done

for silencer1 in ${silencers[@]}
do
    s1=Published-Silencers/$silencer1/Positive-cCREs.bed
    echo $silencer1 > tmp.col
    for silencer2 in ${silencers[@]}
    do
        s2=Published-Silencers/$silencer2/Positive-cCREs.bed
        awk 'FNR==NR {x[$4];next} ($4 in x)' $s1 $s2 | awk '{print $1}' | wc -l | awk '{print $1}' >> tmp.col
    done
    paste tmp.matrix tmp.col > tmp.tmp
    mv tmp.tmp tmp.matrix
done

mv tmp.matrix Figure-Input-Data/Supplementary-Figure-18a.Published-Silencer-Overlap.txt
