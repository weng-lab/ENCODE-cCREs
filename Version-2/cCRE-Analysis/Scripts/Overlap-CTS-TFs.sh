#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

j=$SLURM_ARRAY_TASK_ID
mkdir -p /tmp/moorej3/$SLURM_JOBID-$j
cd /tmp/moorej3/$SLURM_JOBID-$j

biosample=$1
tfList=$2
masterDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38
masterList=$masterDir/Cell-Type-Specific/Master-Cell-List.txt
dataDir=/data/projects/encode/data

file=$(awk '{if ($9 == "'$biosample'") print $2}' $masterList)
grep -v "Low-DNase" $masterDir/Cell-Type-Specific/Seven-Group/$file*.bed > tmp.ccres

bedtools=~/bin/bedtools2/bin/bedtools
dset=$(awk '{if (NR == '$j') print $1}' $tfList)
dpeak=$(grep $dset $tfList | awk '{print $2}')
cell=$(grep $dset $tfList | awk '{print $3}')
target=$(grep $dset $tfList | awk '{print $4}')
group=$(grep $dset $tfList | awk '{print $5}')

if [ "$dpeak" != "" ]
then

    cp $dataDir/$dset/$dpeak.bed.gz bed.gz
    gunzip bed.gz

    total=$(wc -l bed | awk '{print $1}')
    all=$($bedtools intersect -u -a bed -b tmp.ccres | wc -l | awk '{print $1}')

else
    total=1
    all=1
    hq=1
    dpeak="NA"
    cell=$(grep $dset $tfList | awk '{print $3}')
    target=$(grep $dset $tfList | awk '{print $4}')
    group="NA"
fi

awk -v var="$cell" 'BEGIN{print "'$dset'" "\t" "'$dpeak'" "\t" var "\t" \
    "'$target'" "\t" '$total' "\t" '$all'/'$total' "\t" "'$group'"}'
 
rm -r /tmp/moorej3/$SLURM_JOBID-$j
