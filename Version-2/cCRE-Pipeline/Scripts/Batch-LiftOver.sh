#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 10 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab

#Script performs batch liftOver from one assembly to another
#Executed by 10_Homologous-cCREs.sh
#Designed to run on Slurm

mkdir -p /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
cd /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

j=$SLURM_ARRAY_TASK_ID

genome=$1
version=$2
chain=$3
match=$4
newGenome=$5
outputDir=$6

output=$genome"-"$newGenome

bed=~/Lab/ENCODE/Encyclopedia/$version/Registry/$version"-"$genome/$genome-ccREs-Simple.bed

N=$(awk 'BEGIN{print '$j'*1000}')
head -n $N $bed | tail -n 1000 > bed

~/bin/liftOver bed $chain $output.$j.txt $output.$j.NO.txt -minMatch=$match
mv $output.$j.txt $output.$j.NO.txt $outputDir

rm -r /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
