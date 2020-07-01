#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 9 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab

#TO RUN:
#./9_Determine-Closest-Genes.sh {genome}

genome=$1

dir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
ccres=$dir/$genome-ccREs-Simple.bed
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline

num=$(wc -l $ccres | \
    awk 'function ceil(x, y){y=int(x); return(x>y?y+1:y)} {print ceil($1/100)}')

mode=All 
sbatch --nodes 1 --array=1-$num%20 --mem=5G --time=04:00:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    Closest-Genes.sh $ccres $mode $genome

mode=PC
sbatch --nodes 1 --array=1-$num%20 --mem=5G --time=04:00:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    Closest-Genes.sh $ccres $mode $genome
