#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Script calculates overlap between cell type-specific cCREs & ChromHMM states

#TO RUN:
#./Supplementary-Figure-8c.Mouse-ChromHMM-Overlap.sh

files=$1
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-mm10/

echo -e "Tissue \t Group \t Total-cCREs \t TSS \t Bivalent-TSS \t Transcription \t" \
    "Strong-Enhancer \t Weak-Enhancer \t Insulator \t Repressed" > tmp.results

l=$(wc -l $files | awk '{print $1}')
for j in $(seq $l)
do
    experiment=$(awk -F "\t" '{if (NR=='$j') print $1}' $files)
    tissue=$(awk -F "\t" '{if (NR=='$j') print $2}' $files)
    bed=$dataDir/Cell-Type-Specific/Seven-Group/$experiment*.bed
    chromhmm=$dataDir/Manuscript-Analysis/ChromHMM/DAC-Mouse-ChromHMM/$tissue"_mm10_15_segments.bed"
    echo "Processing" $tissue "..."

    datasets=("PLS" "pELS" "dELS" "DNase-H3K4me3" "DNase-only")
    for l in ${datasets[@]}
    do
        echo -e "\t Processing" $l "..."
        grep $l $bed > tmp.bed
        bedtools intersect -wo -a tmp.bed -b $chromhmm > tmp.intersect
        python $scriptDir/choose-majority-chromhmm-state.py tmp.intersect 4 15 16 > tmp.filter

        count=$(wc -l tmp.filter | awk '{print $1}')
        #TSS & Flanking
        A=$(awk '{if ($2 == "E8" || $2 == "E7" || $2 == "E9") print $0}' tmp.filter | wc -l | awk '{print $1/'$count'}')
        #TSS Bivalent
        B=$(awk '{if ($2 == "E11") print $0}' tmp.filter | wc -l | awk '{print $1/'$count'}')
        #Transcription
        C=$(awk '{if ($2 == "E1" || $2 == "E2") print $0}' tmp.filter | wc -l | awk '{print $1/'$count'}')
        #Enhancer
        D=$(awk '{if ($2 == "E6" || $2 == "E4" || $2 == "E5") print $0}' tmp.filter | wc -l | awk '{print $1/'$count'}')
        #Weak Enhancer
        E=$(awk '{if ($2 == "E10" || $2 == "E3") print $0}' tmp.filter | wc -l | awk '{print $1/'$count'}')
        #Repressed
        F=$(awk '{if ($2 == "E12" || $2 == "E15" || $2 == "E13" || $2 == "E14") print $0}' tmp.filter \
            | wc -l | awk '{print $1/'$count'}')
        echo -e $tissue "\t" $l "\t" $count "\t" $A "\t" $B "\t" $C "\t" $D "\t" $E "\t" $F >> tmp.results
    done
done

mv tmp.results Mouse-Tissue.cCRE-ChromHMM-Overlap-Summary.txt
