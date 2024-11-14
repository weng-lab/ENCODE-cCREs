#!/bin/bash

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Anchor-TF-Overlap/Conservation
bed=$workingDir/$key.bed
scriptDir=~/Projects/ENCODE/Encyclopedia/Version7/cCRE-Analysis
bigWig=~/Lab/Reference/Human/hg38/Conservation/hg38_240mammal_phyloP.bw


cd $workingDir

echo "x" > tmp.matrix
for i in `seq -500 1 500`
do
    echo $i >> tmp.matrix
done


keys=(ATF-Sites CEBPB-Sites MAF-Sites rDHS-100k Background.No-cCREs.100k)
for key in ${keys[@]}
do
    echo $key
    bed=$workingDir/$key.bed
    #$scriptDir/Run-Aggregate-Signal.sh $key $workingDir $bigWig $bed
    paste tmp.matrix Output/$key/*.summary > tmp.col
    mv tmp.col tmp.matrix
done
mv tmp.matrix $workingDir/Aggregate-Conservation.240-Mammal.txt
