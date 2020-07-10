#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Script calculates overlap between cell type-specific cCREs & ChromHMM states

#TO RUN:
#./Supplementary-Figure-8b.pELS-ChromHMM-TSS-Distance.sh

biosample=GM12878
dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
masterList=$dataDir/Cell-Type-Specific/Master-Cell-List.txt
chain=~/Lab/Reference/Human/hg38/hg38ToHg19.over.chain
tss=~/Lab/Reference/Human/hg38/GENCODE24/TSS.Basic.bed
chromhmm=$dataDir/Manuscript-Analysis/ChromHMM/ENCFF001TDH.bed

file=$(grep $biosample $masterList | awk '{print $2"_"$4"_"$6"_"$8".7group.bed"}')
ccres=$dataDir/Cell-Type-Specific/Seven-Group/$file

grep pELS $ccres | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' > tmp.ccres
sort -k4,4 tmp.ccres > tmp.sorted
bedtools closest -d -a tmp.ccres -b $tss | awk '{print $4 "\t" $NF}' | \
    sort -k1,1 > tmp.distance
paste tmp.sorted tmp.distance > tmp.union

echo -e "Distance \t Total-cCREs \t TSS \t Bivalent-TSS \t Transcription \t" \
    "Strong-Enhancer \t Weak-Enhancer \t Insulator \t Repressed" >> tmp.results

for j in `seq 0 100 2000`
do
    echo "Processing" $j "..."
    awk '{if ($NF > '$j' && $NF <= '$j'+100) print $1 "\t" $2 "\t" $3 "\t" $4}' \
        tmp.union | sort -k1,1 -k2,2n > tmp.group
    ~/bin/liftOver tmp.group $chain tmp.bed tmp.no-map
    k=$(wc -l tmp.bed | awk '{print $1}')
    bedtools intersect -wo -a tmp.bed -b $chromhmm > tmp.intersect
    python $scriptDir/choose-majority-chromhmm-state.py tmp.intersect 4 8 14 > tmp.filter
    A=$(awk '{if ($2 == "1_Active_Promoter" || $2 == "2_Weak_Promoter") print $0}' tmp.filter \
        | wc -l | awk '{print $1}')
    B=$(awk '{if ($2 == "3_Poised_Promoter") print $0}' tmp.filter | wc -l | awk '{print $1}')
    C=$(awk '{if ($2 == "10_Txn_Elongation" || $2 == "9_Txn_Transition" || \
        $2 == "11_Weak_Txn") print $0}' tmp.filter | wc -l | awk '{print $1}')
    D=$(awk '{if ($2 == "5_Strong_Enhancer" || $2 == "4_Strong_Enhancer") print $0}' tmp.filter \
        | wc -l | awk '{print $1}')
    E=$(awk '{if ($2 == "7_Weak_Enhancer" || $2 == "6_Weak_Enhancer") print $0}' tmp.filter \
        | wc -l | awk '{print $1}')
    F=$(awk '{if ($2 == "8_Insulator") print $0}' tmp.filter | wc -l | awk '{print $1}')
    G=$(awk '{if ($2 == "15_Repetitive/CNV" || $2 == "14_Repetitive/CNV" || \
        $2 == "13_Heterochrom/lo" || $2 == "12_Repressed") print $0}' tmp.filter \
        | wc -l | awk '{print $1}')
    echo -e $j "\t" $k "\t" $A "\t" $B "\t" $C "\t" $D "\t" $E "\t" $F "\t" $G >> tmp.results
done

mv tmp.results $biosample.cCRE-ChromHMM-pELS-Distance-Summary.txt

rm tmp*
