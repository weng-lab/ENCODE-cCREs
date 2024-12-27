#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024
#Step 4 - Calculate signal zscores

#!/bin/bash

genome=$1
mode=$2

dir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome
files=$dir/$mode-List.txt
#files=$3
output=$dir/signal-output
scriptDir=~/Projects/ENCODE/Encyclopedia/Version7/cCRE-Pipeline
peaks=$dir/$genome-Anchors.bed

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
sbatch --nodes 1 --array=1-$num%100 --mem=5G --time=04:00:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    $scriptDir/Retrieve-Signal.sh $peaks $mode $files $output $genome $width

