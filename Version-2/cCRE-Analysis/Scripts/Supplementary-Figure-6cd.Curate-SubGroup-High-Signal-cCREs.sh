#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#To run on Slurm cluster:
# ./Supplementary-Figure-6cd.Batch-Run-cCRE-Saturation.sh {mode}

#For Supplementary-Figure-6c: mode = {ENCODE2, ENCODE2ROADMAP}
#For Supplementary-Figure-6d: mode = {CellLine, PrimaryCell, Tissue}

mode=$2
genome=$1

fileDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
outputDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Manuscript-Analysis/Data-Contribution

mkdir -p $outputDir
echo "Processing Files ..."
file=$fileDir/Biosample-Summaries/$mode-List.txt

mkdir -p $outputDir/signal-output/$mode
q=$(wc -l $file | awk '{print $1}')
for j in `seq 1 1 $q`
do
A=$(awk '{if (NR == '$j') print $1}' $file)
B=$(awk '{if (NR == '$j') print $2}' $file)
C=$( awk '{if (NR == '$j') print $3}' $file)
cp $fileDir/signal-output/$A"-"$B.txt $outputDir/signal-output/$mode/
done

echo "Creating Matrix..."
cd $outputDir/signal-output/$mode/
paste *.txt | \
awk '{printf "%s\t", $1; for(i=2;i<=NF;i+=4) printf "%s\t",$i ; print ""}' > matrix

echo "Determining maxZ..."
python ~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline/max.zscore.array.py matrix > \
    $outputDir/$genome-$mode-maxZ.txt

