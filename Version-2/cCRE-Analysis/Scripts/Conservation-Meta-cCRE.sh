#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

mode=$1
genome=$2

mkdir -p /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
cd /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

N=$(awk 'BEGIN {print '$SLURM_ARRAY_TASK_ID'*100}')
ccres=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Conservation/$mode.bed

head -n $N $ccres | tail -n 100 > mini

scriptDir=/home/moorej3/Projects/ENCODE/Encyclopedia/Version5/ccRE-Analysis

if [[ $genome == "mm10" ]]
then
conDir=~/Lab/Reference/Mouse/Conservation
bigWig=$conDir/mm10.60way.phyloP60way.bw
elif [[ $genome == "hg38" ]]
then
conDir=~/Lab/Reference/Human/$genome/Conservation
bigWig=$conDir/$genome.phyloP100way.bw
fi

f=mini
rm -f header1 header2

for i in `seq -250 1 250`
do
    echo -e 0 "\t" 0 >> header1
    echo -e 0 "\t" 0 >> header2
done

for j in `seq 1 1 100`
do
    echo $j
    chrom=$(awk '{if (NR == '$j') print $1}' $f)
    start=$(awk '{if (NR == '$j') print $2}' $f)
    stop=$(awk '{if (NR == '$j') print $3}' $f)
    python $scriptDir/per-bp.py $chrom $start $stop > mini.bed
    ~/bin/bigWigAverageOverBed $bigWig mini.bed out1.tab
    sort -k1,1g out1.tab | awk '{print $5}' > col1
    paste header1 col1 | awk '{print $1+1 "\t" $2+$3}' > tmp1
    mv tmp1 header1
done

outputDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Conservation/Meta-ccRE/$mode
mkdir -p $outputDir

mv header1 $outputDir/phyloP-Vert.$mode.$SLURM_ARRAY_TASK_ID

rm -r /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
