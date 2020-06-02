#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#To run on Slurm cluster:
# ./Supplementary-Figure-6b.Batch-Run-cCRE-Saturation.sh {group}

#group = {PLS, pELS, dELS, DNase-H3K4me3, CTCF-only}

group=$1
if [ $group == "PLS"  || $group == "DNase-H3K4me3" ]
then
col=4
elif [ $group == "pELS" || $group == "dELS" ]
then
col=6
elif [ $group == "pELS" ]
then
col=8
else
echo "Error: please select PLS, pELS, dELS, DNase-H3K4me3, or CTCF-only as a group"
fi


dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/
masterList=$dataDir/Cell-Type-Specific/Master-Cell-List.txt
p=$(awk '{if ($1 != "---" && $'$col' != "---") print $0}' $masterList | wc -l | awk '{print $1}')

for N in `seq 1 1 $p`
do
    jobid=$(sbatch --nodes 1 --array=1-100%30 --mem=25G --time=04:00:00 \
        --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
        --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
        --partition=4hours \
        Supplementary-Figure-6b.Execute-cCRE-Saturation.sh \
        $col $N $group | awk '{print $4}')
    echo $jobid

    sleep 5
    list=100
    while [ $list -gt 1 ]
    do
        list=$(squeue -j $jobid | wc -l | awk '{print $1}')
        echo -e $N ": jobs still running: $list"
        sleep 5
    done
done
