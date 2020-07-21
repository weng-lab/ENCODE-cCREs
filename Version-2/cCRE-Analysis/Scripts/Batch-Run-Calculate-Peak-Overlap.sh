#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng


genome=$1

j=$SLURM_ARRAY_TASK_ID
mkdir -p /tmp/moorej3/$SLURM_JOBID"-"$j
cd /tmp/moorej3/$SLURM_JOBID"-"$j

dir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
outputDir=$dir/Manuscript-Analysis/Peak-Overlap
mkdir -p $outputDir/

scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
masterList=$dir/Cell-Type-Specific/Master-Cell-List.txt
ccres=$dir/$genome-ccREs-Simple.bed
bedtools=~/bin/bedtools2/bin/bedtools

group=$(awk -F "\t" '{if (NR == '$j') print $10}' $masterList)
biosample=$(awk -F "\t" '{if (NR == '$j') print $9}' $masterList)

if [ $group == "Group8" ] || [ $group == "Group9" ] \
    || [ $group == "Group10" ] || [ $group == "Group13" ]
then
    exp=$(awk -F "\t" '{if (NR == '$j') print $3}' $masterList)
    bed=$(python $scriptDir/retrieve.peak.accession.py $exp histone $genome)
    cp /data/projects/encode/data/$exp/$bed.bed.gz bed.gz
    gunzip bed.gz
    sort -k1,1 -k2,2n bed > sorted.bed
    $bedtools merge -d 200 -c 9 -o max -i sorted.bed | \
        awk '{if ($4 > 2) print $0}' | sort -k4,4rg > bed
    fdr=$(awk '{sum += $4}END{print sum/NR}' bed)
    total=$(wc -l bed | awk '{print $1}')
    $bedtools intersect -u -a bed -b $ccres | wc -l | \
        awk '{print "'$biosample'" "\t" $1/'$total'*100 "\t" '$fdr'"\t" \
        "'$exp'" "\t" $1 "\t" "'$total'"}' > H3K4me3.$exp
    rm bed sorted.bed
fi


if [ $group == "Group8" ] || [ $group == "Group11" ] \
    || [ $group == "Group15" ] || [ $group == "Group13" ]
then
    exp=$(awk -F "\t" '{if (NR == '$j') print $5}' $masterList)
    bed=$(python $scriptDir/retrieve.peak.accession.py $exp histone $genome)
    
    cp /data/projects/encode/data/$exp/$bed.bed.gz bed.gz
    gunzip bed.gz
    sort -k1,1 -k2,2n bed > sorted.bed
    $bedtools merge -d 200 -c 9 -o max -i sorted.bed | \
        awk '{if ($4 > 2) print $0}' | sort -k4,4rg > bed
    fdr=$(awk '{sum += $4}END{print sum/NR}' bed)
    total=$(wc -l bed | awk '{print $1}')
    $bedtools intersect -u -a bed -b $ccres | wc -l | \
        awk '{print "'$biosample'" "\t" $1/'$total'*100 "\t" '$fdr'"\t" \
        "'$exp'" "\t" $1 "\t" "'$total'"}' > H3K27ac.$exp
    rm bed sorted.bed
fi

if [ $group == "Group9" ] || [ $group == "Group12" ] \
    || [ $group == "Group15" ] || [ $group == "Group13" ]
then
    exp=$(awk -F "\t" '{if (NR == '$j') print $7}' $masterList)
    bed=$(python $scriptDir/retrieve.peak.accession.py $exp CTCF $genome)
    
    cp /data/projects/encode/data/$exp/$bed.bed.gz bed.gz
    gunzip bed.gz
    sort -k1,1 -k2,2n bed > sorted.bed
    $bedtools merge -d 200 -c 9 -o max -i sorted.bed | \
        awk '{if ($4 > 2) print $0}' | sort -k4,4rg > bed
    fdr=$(awk '{sum += $4}END{print sum/NR}' bed)
    total=$(wc -l bed | awk '{print $1}')
    $bedtools intersect -u -a bed -b $ccres | wc -l | \
        awk '{print "'$biosample'" "\t" $1/'$total'*100 "\t" '$fdr' "\t" "'$exp'"}' > CTCF.$exp
    rm bed sorted.bed
fi

mv H3K27ac.* CTCF.* H3K4me3.* $outputDir/
rm -r /tmp/moorej3/$SLURM_JOBID"-"$j
