#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Script calculates overlap between cell type-specific cCREs & ChromHMM states

#TO RUN:
#./10_Homologous-cCREs.sh

biosample=GM12878
dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
masterList=$dataDir/Cell-Type-Specific/Master-Cell-List.txt
chain=~/Lab/Reference/Human/hg38/hg38ToHg19.over.chain
chromhmm=$dataDir/Manuscript-Analysis/ChromHMM/ENCFF001TDH.bed

file=$(grep $biosample $masterList | awk '{print $2"_"$4"_"$6"_"$8".7group.bed"}')
ccres=$dataDir/Cell-Type-Specific/Seven-Group/$file

~/bin/liftOver -bedPlus=9 $ccres $chain tmp.yes-map tmp.no-map
awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $10}' tmp.yes-map > tmp.ccres-hg19

echo -e "Group \t Total-cCREs \t TSS \t Bivalent-TSS \t Transcription \t" \
    "Strong-Enhancer \t Weak-Enhancer \t Insulator \t Repressed" >> tmp.results
datasets=("PLS" "pELS" "dELS" "DNase-H3K4me3" "CTCF-only" "DNase-only" "Low-DNase")
for l in ${datasets[@]}
do
    echo "Processing" $l "..."
    grep $l tmp.ccres-hg19 > tmp.bed
    k=$(wc -l tmp.bed | awk '{print $1}')
    bedtools intersect -wo -a tmp.bed -b $chromhmm > tmp.intersect
    python $scriptDir/choose-majority-chromhmm-state.py tmp.intersect 4 9 15 > tmp.filter
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
    echo -e $l "\t" $k "\t" $A "\t" $B "\t" $C "\t" $D "\t" $E "\t" $F "\t" $G >> tmp.results
done

mv tmp.results $biosample.cCRE-ChromHMM-Overlap-Summary.txt

rm tmp*
