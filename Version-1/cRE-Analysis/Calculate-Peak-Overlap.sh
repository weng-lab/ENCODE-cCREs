#!/bin/bash

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017

#./Calculate-Peak-Overlap.sh PeakList.txt cREs.bed

peakList=$1
cREs=$2
dataDir=/data/projects/encode/data

l=$(wc -l $peakList | awk '{print $1}')
for j in $(seq $l)
do
    experiment=$(awk '{if (NR == '$j') print $1}' $peakList)
    peaks=$(awk '{if (NR == '$j') print $2}' $peakList)
    cp $dataDir/$experiment/$peaks.bed.gz h.bed.gz
    gunzip h.bed.gz
    sort -k1,1 -k2,2n h.bed > sorted.bed
    bedtools merge -d 200 -c 9 -o max -i sorted.bed | \
        awk '{if ($4 > 2) print $0}' | sort -k4,4rg > bed2
    awk '{if ($4 > 5) print $0}' bed2 > bed5
    count2=$(wc -l bed2 | awk '{print $1}')
    count5=$(wc -l bed5 | awk '{print $1}')
    A=$(bedtools intersect -u -a bed2 -b $cREs | wc -l | awk '{print $1/'$count2'}')
    B=$(bedtools intersect -u -a bed5 -b $cREs | wc -l | awk '{print $1/'$count5'}')
    echo -e $experiment "\t" $A "\t" $B
    rm h.bed sorted.bed bed2 bed5
done

