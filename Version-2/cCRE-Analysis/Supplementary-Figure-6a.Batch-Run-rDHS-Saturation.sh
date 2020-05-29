#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#To run on Slurm cluster:
# ./Supplementary-Figure-6a.Batch-Run-rDHS-Saturation.sh

genome=hg38

for N in `seq 25 25 525`
do
    jobid=$(sbatch --nodes 1 --array=1-100%25 --mem=25G --time=04:00:00 \
        --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
        --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
	--partition=4hours \
        Supplementary-Figure-6a.Execute-rDHS-Saturation.sh \
        $genome $N | awk '{print $4}')
    echo $jobid
done
