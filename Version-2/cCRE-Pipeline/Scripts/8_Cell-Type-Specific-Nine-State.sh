#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 8 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab

#TO RUN:
#./8_Cell-Type-Specific-Nine-State.sh {genome}

genome=$1
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline
fileDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome

DNase=$fileDir/DNase-List.txt
num=$(wc -l $DNase | awk '{print $1}')
sbatch --nodes 1 --array=1-$num%50 --mem=1G --time=00:30:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A.output \
    --error=/home/moorej3/Job-Logs/jobid_%A.error \
    $scriptDir/Nine-State-Master.sh \
    $DNase "6,218,147" "High-DNase-Signal" $genome

CTCF=$fileDir/CTCF-List.txt
num=$(wc -l $CTCF | awk '{print $1}')
sbatch --nodes 1 --array=1-$num%50 --mem=1G --time=00:30:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A.output \
    --error=/home/moorej3/Job-Logs/jobid_%A.error \
    $scriptDir/Nine-State-Master.sh \
    $CTCF "0,176,240" "High-CTCF-Signal" $genome

H3K27ac=$fileDir/H3K27ac-List.txt
num=$(wc -l $H3K27ac | awk '{print $1}')
sbatch --nodes 1 --array=1-$num%50 --mem=1G --time=00:30:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A.output \
    --error=/home/moorej3/Job-Logs/jobid_%A.error \
    $scriptDir/Nine-State-Master.sh \
    $H3K27ac "255,205,0" "High-H3K27ac-Signal" $genome

H3K4me3=$fileDir/H3K4me3-List.txt
num=$(wc -l $H3K4me3 | awk '{print $1}')
sbatch --nodes 1 --array=1-$num%50 --mem=1G --time=00:30:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A.output \
    --error=/home/moorej3/Job-Logs/jobid_%A.error \
    $scriptDir/Nine-State-Master.sh \
    $H3K4me3 "255,0,0" "High-H3K4me3-Signal" $genome



