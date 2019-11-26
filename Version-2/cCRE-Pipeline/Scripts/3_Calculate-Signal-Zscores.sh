#!/bin/bash

#Step 3 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab
#November 2019

#TO RUN:
#./3_Calculate-Signal-Zscores.sh {genome: hg38, mm10} {mode: DNase, H3K4me3, H3K27ac, CTCF}

genome=$1
mode=$2

dir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
files=$dir/$mode-List.txt
output=$dir/signal-output
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline

peaks=$dir/$genome-rDHS-Filtered.bed

if [ $mode == "DNase" ] || [ $mode == "CTCF" ] || [ $mode == "POL2" ]
then
    width=0
else
    width=500
fi
echo $width

##Step 1 - Retreive Signal Rank###

num=$(wc -l $files | awk '{print $1}')
sbatch --nodes 1 --array=1-$num%50 --mem=5G --time=04:00:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    RetrieveSignal.sh $peaks $mode $files $output $genome $width

