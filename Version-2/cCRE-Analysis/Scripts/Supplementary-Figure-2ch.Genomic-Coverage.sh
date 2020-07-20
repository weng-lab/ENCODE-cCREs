#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-2ch.Genomic-Coverage.sh [genome]

genome=$1
dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
ccres=$dataDir/$genome-ccREs-Simple.bed

if [[ $genome == "mm10" ]]
then
    chromSize=~/Lab/Reference/Mouse/ChromInfo.txt
elif [[ $genome == "hg38" ]]
then
    chromSize=~/Lab/Reference/Human/hg38/chromInfo.txt
fi

totalGenome=$(awk '{sum += $2}END{print sum}' $chromSize)
totalElements=$(awk '{sum += ($3-$2)}END{print sum}' $ccres)
totalPercent=$(awk 'BEGIN{print '$totalElements'/'$totalGenome'*100}')
echo -e "All-cCREs" "\t" $totalElements "\t" $totalGenome "\t" $totalPercent

groups=(PLS pELS dELS DNase-H3K4me3 CTCF-only)
for group in ${groups[@]}
do
    grep $group $ccres | awk '{sum += $3-$2}END{print "'$group'" "\t" sum "\t" \
        "'$totalGenome'" "\t" sum/'$totalGenome'*100}'
done
