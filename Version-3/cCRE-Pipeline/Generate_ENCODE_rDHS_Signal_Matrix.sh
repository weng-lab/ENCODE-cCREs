#!/bin/bash

# -- Kaili Fan
# Weng Lab, UMass Chan Med
# October, 2022

# This script is for generating ENCODE rDHS DNase/H3K4me3/H3K27ac/CTCF signal matrix.

workDir="/data/zusers/fankaili/ccre/ENCODE4/V3/"
scriptDir="/data/zusers/fankaili/github/weng-lab/Kaili/ccREs/ENCODE4/"

mark="DNase" # or H3K4me3, H3K27ac, CTCF
genome="GRCh38" # or mm10

rDHS_list="/data/projects/encode/Registry/V3/GRCh38/GRCh38-rDHSs.bed"
file_list="/data/projects/encode/Registry/V3/GRCh38/Biosample-Lists/"${mark}"-List.txt"
signal_dir="/data/projects/encode/Registry/V3/GRCh38/Signal-Files/"
prefix=${genome}"."${mark}
suffix="rDHS-V3"

cd ${workDir}
mkdir -p ${workDir}${mark}_matrix
cd ${workDir}${mark}_matrix/
mkdir tmp_${prefix}
###########
# 1. generating signal col for each sample
while read line
do
    expID=`awk '{print $1}' <<< ${line}`
    fileID=`awk '{print $2}' <<< ${line}`
    sample=`awk '{print $3}' <<< ${line}`
    echo ${sample}
    # z-score
    echo ${expID} > ./tmp_${prefix}/tmp.${expID}_zscore.txt
    echo ${sample} >> ./tmp_${prefix}/tmp.${expID}_zscore.txt
    cut -f 1,2 ${signal_dir}${expID}-${fileID}.txt  | sort -k1 | cut -f 2 >> ./tmp_${prefix}/tmp.${expID}_zscore.txt
    # FC
    echo ${expID} > ./tmp_${prefix}/tmp.${expID}_FC.txt
    echo ${sample} >> ./tmp_${prefix}/tmp.${expID}_FC.txt
    cut -f 1,3 ${signal_dir}${expID}-${fileID}.txt | sort -k1 | cut -f 2 >> ./tmp_${prefix}/tmp.${expID}_FC.txt
done < ${file_list}
# 2. merge files into matirx
# z-score
echo "rDHS" > ./tmp_${prefix}/tmp.zscore.txt
echo "rDHS" >> ./tmp_${prefix}/tmp.zscore.txt
cut -f 4 ${rDHS_list} | sort -k1 >> ./tmp_${prefix}/tmp.zscore.txt
paste ./tmp_${prefix}/tmp.zscore.txt ./tmp_${prefix}/tmp.*_zscore.txt > ${prefix}-zscore.${suffix}.txt
# FC
echo "rDHS" > ./tmp_${prefix}/tmp.FC.txt
echo "rDHS" >> ./tmp_${prefix}/tmp.FC.txt
cut -f 4 ${rDHS_list} | sort -k1 >> ./tmp_${prefix}/tmp.FC.txt
paste ./tmp_${prefix}/tmp.FC.txt ./tmp_${prefix}/tmp.*_FC.txt > ${prefix}-FC.${suffix}.txt
