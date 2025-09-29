#!/bin/bash

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Anchor-TF-Overlap/Conservation
scriptDir=~/Projects/ENCODE/Encyclopedia/Version7/cCRE-Analysis
bigWig=~/Lab/Reference/Human/hg38/Conservation/hg38.phastCons100way.bw


cd $workingDir

keys=(ATF-Sites CEBPB-Sites MAF-Sites rDHS-100k TF-Anchors Background.No-cCREs.100k)
for key in ${keys[@]}
do
    echo $key
    bed=$workingDir/$key.bed
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $bed > tmp.bed
    ~/bin/bigWigAverageOverBed $bigWig tmp.bed tmp.out
    awk '{print $1 "\t" $5 "\t" "'$key'"}' tmp.out >> tmp.summary
done

