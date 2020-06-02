#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Runs on Slurm cluster and is run by
#Supplementary-Figure-6b.Batch-Run-cCRE-Saturation.sh

col=$1
N=$2
group=$3

dir=/home/moorej3/scratch/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/
master=$dataDir/hg38-ccREs-Simple.bed
masterList=$dataDir/Cell-Type-Specific/Master-Cell-List.txt
outputDir=$dataDir/Revision-2-Analysis/Saturation/$group

mkdir -p $outputDir
mkdir -p $dir
cd $dir


awk '{if ($1 != "---" && $'$col' != "---") print $0}' $masterList > tmp
sort -R tmp | head -n $N > list

rm -f running-list
for j in `seq 1 1 $N`
do
    echo $j
    d=$(awk '{if (NR == '$j') print $2}' list)
    ccre=$dataDir/Cell-Type-Specific/Seven-Group/$d*.bed
    ls $ccre | wc -l | awk '{print "\t" $1}'
    grep -v Low-DNase $ccre >> running-list
done

grep $group $master > master-list
awk 'FNR==NR {x[$4];next} ($5 in x)' running-list master-list > output

wc -l output | awk '{print "'$N'" "\t" $1}' > $outputDir/$N.$SLURM_ARRAY_TASK_ID

cd ..
rm -r $dir
