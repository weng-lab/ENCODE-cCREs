#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-7.ChIP-Peak-Overlap.sh [genome]

genome=$1

dir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
masterList=$dir/Cell-Type-Specific/Master-Cell-List.txt

num=$(wc -l $masterList | awk '{print $1}')
sbatch --nodes 1 --array=1-$num%25 --mem=10G --time=00:30:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    Batch-Run-Calculate-Peak-Overlap.sh $genome

