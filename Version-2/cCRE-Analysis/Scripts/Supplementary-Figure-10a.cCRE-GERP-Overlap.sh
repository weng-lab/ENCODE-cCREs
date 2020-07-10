#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-10a.cCRE-GERP-Overlap.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
ccre=$dataDir/hg38-ccREs-Simple.bed
gerp=$dataDir/Conservation/GERP
chain=~/Lab/Reference/Human/hg19/hg19ToHg38.over.chain

files=$(ls $gerp/hg19*.txt)

rm -f GERP-Regions-hg19.txt
for file in ${files[@]}
do
    echo "Processing" $file "..."
    chrom=$(echo $file | awk -F "_" '{print $2}')
    awk '{print "'$chrom'" "\t" $0}' $file >> GERP-Regions-hg19.txt
done

~/bin/liftOver GERP-Regions-hg19.txt $chain GERP-Regions-hg38.txt tmp.no-map

bedtools intersect -wo -a $ccre -b GERP-Regions-hg38.txt > tmp.output
python $scriptDir/process-gerp.py $dataDir/hg38-DNase-maxZ.txt tmp.output $ccre \
    > hg38-GERP-Summary.txt

rm tmp.*
