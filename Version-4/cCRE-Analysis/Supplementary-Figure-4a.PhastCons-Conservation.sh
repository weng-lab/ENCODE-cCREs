#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 4a

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Conservation
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
bw=~/Lab/Reference/Human/hg38/Conservation/hg38.phastCons100way.bw

cd $workingDir

classes=$(awk '{print $NF}' $ccres | sort -u )
for class in ${classes[@]}
do
    echo $class
    awk '{if ($NF == "'$class'") print $1 "\t" $2 "\t" $3 "\t" $4}' $ccres > tmp.bed
    ~/bin/bigWigAverageOverBed $bw tmp.bed tmp.out
    awk '{print $1 "\t" $5 "\t" "'$class'"}' tmp.out >> tmp.conservation
done

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' ../Background.No-cCREs.100k.bed > tmp.bed
~/bin/bigWigAverageOverBed $bw tmp.bed tmp.out
awk '{print $1 "\t" $5 "\t" "background"}' tmp.out >> tmp.conservation

mv tmp.conservation ../Figure-Input-Data/Supplementary-Figure-4a.PhastCons-Conservation.txt
rm tmp.*
