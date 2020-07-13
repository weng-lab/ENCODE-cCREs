#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-11ab.cCRE-TF-Overlap.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/Manuscript-Analysis/TF-Overlap/
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts

files=$dataDir/All-Biosample-Filtered-TF-List.txt
num=$(wc -l $files | awk '{print $1}')
jobid=$(sbatch --nodes 1 --array=1-$num%20 --mem=10G --time=00:30:00 \
       --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
       --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
       $scriptDir/Overlap-TFs.sh $files | awk '{print $4}')
echo $jobid
sleep 20
list=100
while [ $list -gt 1 ]
do
    list=$(squeue -j $jobid | wc -l | awk '{print $1}')
    echo -e "jobs still running: $list"
    sleep 10
done
cat ~/Job-Logs/jobid_$jobid*.output > $dataDir/All-Biosample.cCRE-TF-Overlap-Results.txt

#biosamples=(GM12878 HepG2 K562)
#for biosample in ${biosamples[@]}
#do
#    echo "Processing" $biosample "..."
#    files=$dataDir/$biosample-Filtered-TF-List.txt
#    num=$(wc -l $files | awk '{print $1}')
#    jobid=$(sbatch --nodes 1 --array=1-$num%20 --mem=10G --time=00:30:00 \
#       --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
#       --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
#       $scriptDir/Overlap-CTS-TFs.sh $biosample $files | awk '{print $4}')
#    sleep 20
#    list=100
#    while [ $list -gt 1 ]
#    do
#        list=$(squeue -j $jobid | wc -l | awk '{print $1}')
#        echo -e "jobs still running: $list"
#        sleep 10
#    done
#    cat ~/Job-Logs/jobid_$jobid*.output > $dataDir/$biosample.cCRE-TF-Overlap-Results.txt
#done
