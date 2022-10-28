#!/bin/bash
#Jill E. Moore
#Weng Lab
#UMass Medical School
#Updated October 2017

#ENCODE Encyclopedia Version 5

genome=$1
mode=$2

dir=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-$genome
files=$dir/$mode-List.txt
output=$dir/signal-output
scriptDir=~/Projects/ENCODE/Encyclopedia/Version6/cCRE-Pipeline
peaks=$dir/$genome-rDHS/$genome-rDHS-Filtered.bed

mkdir -p $output

if [ $mode == "DNase" ] || [ $mode == "CTCF" ] || [ $mode == "POL2" ] || [ $mode == "ATAC" ]
then
    width=0
else
    width=500
fi
echo $width

##Step 1 - Retreive Signal Rank###

num=$(wc -l $files | awk '{print $1}')
sbatch --nodes 1 --array=1-$num%20 --mem=5G --time=04:00:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    $scriptDir/Retrieve-Signal.sh $peaks $mode $files $output $genome $width

