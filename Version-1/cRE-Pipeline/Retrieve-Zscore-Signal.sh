#!/bin/bash

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017

#Script for retreiving and ranking signal

source ~/.bashrc

peaks=$1
width=$2
files=$3
genome=$4

dataDir=/project/umw_zhiping_weng/0_metadata/encode/data
outputDir=/home/jm36w/Lab/Results/V4-$genome/signal-output

experiment=$(awk -F "\t" '{if (NR=='$LSB_JOBINDEX') print $1}' $files)
signal=$(awk -F "\t" '{if (NR=='$LSB_JOBINDEX') print $2}' $files)

mkdir -p /tmp/jm36w/$LSB_JOBID"-"$LSB_JOBINDEX
cd /tmp/jm36w/$LSB_JOBID"-"$LSB_JOBINDEX

awk -F "\t" '{printf "%s\t%.0f\t%.0f\t%s\n", $1,$2-'$width',$3+'$width',$4}' \
    $peaks | awk '{if ($2 < 0) print $1 "\t" 0 "\t" $3 "\t" $4 ; else print $0}' \
    | sort -u > little

~/bin/bigWigAverageOverBed -bedOut=out2.bed $dataDir/$experiment/$signal.bigWig \
    little out2

python ~/Projects/ENCODE/Encyclopedia/Version4/zscore.normalization.py out2 > l

sort -k2,2rg l | awk 'BEGIN {rank=0; before=0; running=1}{if ($2 != before) \
    rank = running; print $1 "\t" $2 "\t" $3 "\t" rank; before=$2; running += 1}'\
    | sort -k1,1 > $outputDir/$experiment"-"$signal".txt"

cd /home/jm36w/
rm -r /tmp/jm36w/$LSB_JOBID"-"$LSB_JOBINDEX
