#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Overlap distal enhancer with FANTOM enhancers and compare the epigenomic signals of both groups

#TO RUN:
#./Supplementary-Figure-9abcde.FANTOM-Enhancer-Intersection.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/

fantomFull=$dataDir/Manuscript-Analysis/CAGE/human_permissive_enhancers_phase_1_and_2.bed
ccres=$dataDir/hg38-ccREs-Simple.bed
chain=~/Lab/Reference/Human/hg19/hg19ToHg38.over.chain

grep "dELS" $ccres > tmp.dels
awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $fantomFull > tmp.fantom-hg19
~/bin/liftOver tmp.fantom-hg19 $chain FANTOM-enhancer-hg38.bed tmp.no-map

fantom=FANTOM-enhancer-hg38.bed

bedtools intersect -u -a tmp.dels -b $fantom > tmp.yes
bedtools intersect -v -a tmp.dels -b $fantom > tmp.no

data=("DNase" "H3K4me3" "H3K27ac" "H3K4me1" "POL2")
for d in ${data[@]}
do
    echo "Processing" $d "..."
    maxSig=$dataDir/hg38-$d-maxZ.txt
    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.yes $maxSig | awk '{print $1 "\t" \
        $2 "\t" "yes"}' > tmp.A
    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.no $maxSig | awk '{print $1 "\t" \
        $2 "\t" "no"}' >> tmp.A
    mv tmp.A $d-FANTOM-Enhancer-Summary.txt
done

rm tmp.*
