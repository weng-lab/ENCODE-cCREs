#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#This script randomly selects N DNase experiments and run the rDHS pipeline on 
#this subset. This script is meant to run on a Slurm cluster and is called by
#Supplementary-Figure-6a.Batch-Run-rDHS-Saturation.sh 

genome=hg38
N=$2
rep=$SLURM_ARRAY_TASK_ID
output=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Saturation

expList=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/$genome-Hotspot-Experiment-List.txt
hotspotList=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/$genome-Hotspot-List.txt
dhsDir=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/Processed-DHSs
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline
dnaseList=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/$genome-DHS-Saturation-Accessions.txt
dir=/home/moorej3/scratch/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
stamList=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/$genome-Stam-cDHS-All.bed

mkdir -p $dir
cd $dir

if [ $genome == "mm10" ]
then
cutoff=0.1454
elif [ $genome == "hg38" ]
then
cutoff=0.1508
fi

#Random list of N DNase experients
sort -R $expList | head -n $N > tmp

#Retrieve list of relevant hotspot experiment acessions
awk 'FNR==NR {x[$1];next} ($1 in x)' tmp $hotspotList > tmp.hotspot
rm -f dhs

#Creates a master file of all DHSs from all experiments
q=$(wc -l tmp.hotspot | awk '{print $1}')
for j in `seq 1 1 $q`
do
    echo $j
    A=$(awk -F "\t" '{if (NR == '$j') print $3}' tmp.hotspot)
    cat $dhsDir/output.$A.* >> dhs
done

#Filters out DHS that are below thresholds
awk '{if ($1 !~ /_/ && $3-$2 >= 150 && $5 >= '$cutoff' && $9 <= 0.001) print $0}' \
    dhs | grep -v "chrEBV" | grep -v "chrM" | sort -k1,1 -k2,2n > sorted

#Clusters DHSs and selects a representative DHS
num=$(wc -l sorted | awk '{print $1}')
while [ $num -gt 0 ]
do
    echo -e "\t" $num
    ~/bin/bedtools2/bin/bedtools merge -i sorted -c 4,5 -o collapse,collapse > merge
    python $scriptDir/pick.best.peak.py merge > peak-list
    awk 'FNR==NR {x[$1];next} ($4 in x)' peak-list sorted >> rPeaks
    ~/bin/bedtools2/bin/bedtools intersect -v -a sorted -b rPeaks > remaining
    mv remaining sorted
    num=$(wc -l sorted | awk '{print $1}')
done

#Intersects rDHSs with cDHSs selecting those that overlap or have partial coverage
~/bin/bedtools2/bin/bedtools intersect -F 1 -u -a rPeaks -b $stamList > completeCoverage.bed
~/bin/bedtools2/bin/bedtools intersect -F 1 -v -a rPeaks -b $stamList > tmp1
~/bin/bedtools2/bin/bedtools intersect -v -a tmp1 -b $stamList > NoCoverage.bed
~/bin/bedtools2/bin/bedtools intersect -wo -a tmp1 -b $stamList > partialCoverage.bed

awk '{if ($NF >= 135) {out=$1; for(i=2;i<=10;i++){out=out"\t"$i}; print out}}' \
    partialCoverage.bed | sort -u > 135Coverage.bed
awk 'FNR==NR {x[$4];next} !($4 in x)' 135Coverage.bed partialCoverage.bed | \
    awk '{out=$1; for(i=2;i<=9;i++){out=out"\t"$i}; print out}' > LessCoverage.bed

python $scriptDir/percentile.py NoCoverage.bed > percentile.txt
j=90

n=$(awk '{if (NR == '$j') print $2}' percentile.txt)
awk '{if ($5 >= '$n') print $0}' LessCoverage.bed | sort -u > working.bed
cat 135Coverage.bed completeCoverage.bed >> working.bed

#Outputs results to account for N and replicate number
sort -u working.bed | wc -l | awk '{print "'$N'" "\t" $1}' > $output/count.$N.$rep

rm -r /home/moorej3/scratch/$SLURM_JOBID"-"$SLURM_ARRAY_TASK_ID
