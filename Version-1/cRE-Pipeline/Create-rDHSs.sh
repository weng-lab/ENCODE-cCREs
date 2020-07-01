#!/bin/bash

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017

#Script for creating rDHSs given DNase-seq files
genome=hg19
dataDir=/data/projects/encode/data
dataList=$genome-Hotspot-List.txt


l=$(wc -l $dataList  | awk '{print $1}')
for j in $(seq $l)
do
    experiment=$(cat $dataList  | awk '{if (NR == '$j') print $1}')
    peaks=$(cat $dataList  | awk '{if (NR == '$j') print $2}')
    signal=$(cat $dataList  | awk '{if (NR == '$j') print $4}')
    peaks=$dataDir/$experiment/$peaks.bed.gz
    signal=$dataDir/$experiment/$signal.bigWig
    cp $peaks bed.gz
    gunzip bed.gz
    awk '{print $1 "\t" $2 "\t" $3 "\t" "'$experiment'-"NR "\t" $5 "\t" $6 "\t" 1 "\t" 1 "\t" $9}' bed | sort -k4,4 > new
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' new > new.bed
    ~/bin/bigWigAverageOverBed $signal new.bed out.tab
    python ~/Projects/ENCODE/Encyclopedia/Version4/log.normalization.py out.tab > l
    sort -k1,1 out.tab > 1
    paste new out.tab | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $14 "\t" 1 "\t" $9}' >> tmp.bed
    rm new bed out.tab l 1
done

./Cluster-DHSs.sh
mv FINAL.bed $genome-rDHS-FDR3.bed
