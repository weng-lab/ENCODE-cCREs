#!/bin/bash

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017

#This script is designed to run on UMass GHPCC (LSF)
#This script is executed from parent script Run-Calculate-cRE-Saturation.sh

source ~/.bashrc

outputDir=/home/jm36w/Lab/Results/Saturation/
dataDir=/home/jm36w/Lab/Results/V4-hg19/maxZ/Cell-Type-Specific/Bed-BigBed

N=$1
datasets=$2
mode=$3

if [ $mode == "promoter" ]
then
    modeColor="255,0,0"
elif [ $mode == "enhancer" ]
then
    modeColor="255,205,0"
elif [ $mode == "ctcf" ]
then
    modeColor="0,176,240"
else
    modeColor="225,225,225"
fi
        
mkdir -p $outputDir/jobid_$LSB_JOBID/$LSB_JOBINDEX
cd $outputDir/jobid_$LSB_JOBID/$LSB_JOBINDEX/

sort -R $datasets | head -n $N > mini
x=$(wc -l mini | awk '{print $1}')

for j in $(seq $x)
do
    A=$(cat mini | awk '{if (NR == '$j') print $2}')
    B=$(cat mini | awk '{if (NR == '$j') print $4}')
    C=$(cat mini  | awk -F "\t" '{if (NR == '$j') print $6}')
    D=$(cat mini  | awk -F "\t" '{if (NR == '$j') print $8}')
    grep $modeColor $dataDir/$A"_"$B"_"$C"_"$D".cREs.bed" | awk '{print $4}' >> cREs
done

sort -u cREs | wc -l | awk '{print "'$N'" "\t" $1}' >> log.$N
rm mini cREs
