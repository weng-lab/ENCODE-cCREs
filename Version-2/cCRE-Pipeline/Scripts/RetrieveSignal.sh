#!/bin/bash
#Jill E. Moore
#Weng Lab
#UMass Medical School
#Updated August 2016

#ENCODE Encyclopedia Version 5
#Script for retreiving and ranking signal

peaks=$1
mode=$2
files=$3
output=$4
g=$5
width=$6

dataDir=/data/projects/encode/data/
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline

dset=$(awk -F "\t" '{if (NR=='$SLURM_ARRAY_TASK_ID') print $1}' $files)
dsig=$(awk -F "\t" '{if (NR=='$SLURM_ARRAY_TASK_ID') print $2}' $files)
dline=$(awk -F "\t" '{if (NR=='$SLURM_ARRAY_TASK_ID') print $0}' $files)

mkdir -p /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
cd /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

/bin/sleep   `/usr/bin/expr $RANDOM % 60`

awk -F "\t" '{printf "%s\t%.0f\t%.0f\t%s\n", $1,$2-'$width',$3+'$width',$4}' \
$peaks | awk '{if ($2 < 0) print $1 "\t" 0 "\t" $3 "\t" $4 ; else print $0}' \
| sort -u > little

~/bin/bigWigAverageOverBed -bedOut=out2.bed $dataDir/$dset/$dsig.bigWig little out2

python $scriptDir/log.zscore.normalization.py out2 > l

sort -k2,2rg l | awk 'BEGIN {rank=0; before=0; running=1}{if ($2 != before) \
    rank = running; print $1 "\t" $2 "\t" $3 "\t" rank; before=$2; \
    running += 1}' | sort -k1,1 > $output/$dset"-"$dsig".txt"

cd /home/moorej3/
rm -r /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

