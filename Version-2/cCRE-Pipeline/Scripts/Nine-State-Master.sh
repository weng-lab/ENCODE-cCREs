#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

mkdir -p /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
cd /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

j=$SLURM_ARRAY_TASK_ID
data=$1
color=$2
text=$3
genome=$4

fileDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
output=$fileDir/Cell-Type-Specific/Nine-State
cresAS=$fileDir/Cell-Type-Specific/cres.as
ccREs=$fileDir/$genome-ccREs-Simple.bed

if [[ $genome == "mm10" ]]
then
ChromInfo=~/Lab/Reference/Mouse/ChromInfo.txt
elif [[ $genome == "hg38" ]]
then
ChromInfo=~/Lab/Reference/Human/hg38/chromInfo.txt
fi

A=$(awk -F "\t" '{if (NR == '$j') print $1}' $data)
B=$(awk -F "\t" '{if (NR == '$j') print $2}' $data)
awk '{if ($2 > 1.64) print $0}' $fileDir/signal-output/$A"-"$B.txt > list
awk 'FNR==NR {x[$1];next} ($4 in x)' list $cCREs \
    | awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
    "\t" $3 "\t" "'$color'" "\t" "'$text'" "\t" "State-Classification"}' > l.bed
awk 'FNR==NR {x[$4];next} !($5 in x)' l.bed $cCREs \
         | awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "225,225,225" "\t" "Low-Signal" "\t" "State-Classification"}' > p.bed

cat l.bed p.bed | sort -k1,1 -k2,2n > $B.9state.bed

~/bin/bedToBigBed -type=bed9+1 -as=$cresAS $B".9state.bed"\
    $ChromInfo $B".9state.bigBed"
mv $B".9state.bed" $B".9state.bigBed" $output

rm -r /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
