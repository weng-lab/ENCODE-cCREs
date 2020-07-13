#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

masterDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/
ccres=$masterDir/hg38-ccREs-Simple.bed
tfList=$1
dataDir=/data/projects/encode/data
j=$SLURM_ARRAY_TASK_ID

mkdir -p /tmp/moorej3/$SLURM_JOBID-$j
cd /tmp/moorej3/$SLURM_JOBID-$j

bedtools=~/bin/bedtools2/bin/bedtools
dset=$(awk -F "\t" '{if (NR == '$j') print $1}' $tfList)
dpeak=$(grep $dset $tfList | awk -F "\t" '{print $2}')
cell=$(grep $dset $tfList | awk -F "\t" '{print $3}')
target=$(grep $dset $tfList | awk -F "\t" '{print $4}')

if [ "$dpeak" != "" ]
then
    cp $dataDir/$dset/$dpeak.bed.gz bed.gz
    gunzip bed.gz
    total=$(wc -l bed | awk '{print $1}')
    all=$($bedtools intersect -u -a bed -b $ccres | wc -l | awk '{print $1}')
else
    total=1
    all=1
    hq=1
    dpeak="NA"
    cell=$(grep $dset $tfList | awk -F "\t" '{print $3}')
    target=$(grep $dset $tfList | awk -F "\t" '{print $4}')
fi

awk -v var="$cell" 'BEGIN{print "'$dset'" "\t" "'$dpeak'" "\t" var "\t" \
    "'$target'" "\t" '$total' "\t" '$all'/'$total'}'
 
rm -r /tmp/moorej3/$SLURM_JOBID-$j
