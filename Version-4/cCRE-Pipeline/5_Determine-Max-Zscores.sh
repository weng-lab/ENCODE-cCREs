#!/bin/bash

#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024
#Step 5 - Determine maxZ


#CTCF, DNase, H3K27ac, H3K4me3
mode=$2
genome=$1

fileDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Pipeline/Toolkit

echo "Processing Files ..."
file=$fileDir/$mode-List.txt
mkdir -p $fileDir/signal-output/$mode
q=$(wc -l $file | awk '{print $1}')
for j in `seq 1 1 $q`
do
    A=$(awk '{if (NR == '$j') print $1}' $file)
    B=$(awk '{if (NR == '$j') print $2}' $file)
    C=$( awk '{if (NR == '$j') print $3}' $file)
    mv $fileDir/signal-output/$A"-"$B.txt $fileDir/signal-output/$mode/
done

cd $fileDir/signal-output/$mode/

echo "Determining maxZ..."
python $scriptDir/select-max-zscore.py *.txt > $fileDir/$genome-$mode-maxZ.txt
mv *.txt ../

