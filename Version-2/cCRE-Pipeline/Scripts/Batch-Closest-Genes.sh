#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

mkdir -p /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
cd /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

ccres=$1
mode=$2
genome=$3

echo $mode
echo $genome

j=$SLURM_ARRAY_TASK_ID
bedtools=~/bin/bedtools2/bin/bedtools
outputDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Closest-Genes/
mkdir -p $outputDir

if [ $mode == "All" ] && [ $genome == "hg38" ]
then
    genes=~/Lab/Reference/Human/hg38/GENCODE24/Genes.Basic.bed
    tss=~/Lab/Reference/Human/hg38/GENCODE24/TSS.Basic.bed
    chromInfo=~/Lab/Reference/Human/hg38/chromInfo.txt
elif [ $mode == "PC" ] && [ $genome == "hg38" ]
then
    genes=~/Lab/Reference/Human/hg38/GENCODE24/Genes.Basic-PC.bed
    tss=~/Lab/Reference/Human/hg38/GENCODE24/TSS.Basic-PC.bed
    chromInfo=~/Lab/Reference/Human/hg38/chromInfo.txt
elif [ $mode == "All" ] && [ $genome == "mm10" ]
then
    genes=~/Lab/Reference/Mouse/GENCODEM18/Genes.Basic.bed
    tss=~/Lab/Reference/Mouse/GENCODEM18/TSS.Basic.bed
    chromInfo=~/Lab/Reference/Mouse/ChromInfo.txt
elif [ $mode == "PC" ] && [ $genome == "mm10" ]
then
    genes=~/Lab/Reference/Mouse/GENCODEM18/Genes.Basic-PC.bed
    tss=~/Lab/Reference/Mouse/GENCODEM18/TSS.Basic-PC.bed
    chromInfo=~/Lab/Reference/Mouse/ChromInfo.txt
else
    echo "ERROR! invalid selection"
fi

echo $genes
echo $tss
echo $chromInfo

N=$(awk 'BEGIN{print '$j'*100}')

head -n $N $ccres | tail -n 100 | sort -k1,1 -k2,2n > bed
$bedtools closest -k 10 -d -g $chromInfo -a bed -b $genes > OUT

while read p; do
  echo $p | awk '{print $1 "\t" $2 "\t" $3 "\t" $5}' > bed1
  gene=$(echo $p  | awk '{print $10}')
  grep $gene $tss > bed2
  $bedtools closest -d -g $chromInfo -a bed1 -b bed2 >> list
done < OUT

while read p; do
  echo $p
  cre=$(echo $p  | awk '{print $5}')
  grep $cre list | awk '{print $4 "\t" $11 "\t" $12}' | sort -u \
    | sort -k3,3g | head -5 >> $mode"Genes."$j.txt
done < bed

mv $mode"Genes."$j.txt $outputDir

rm -r /tmp/moorej3/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID

