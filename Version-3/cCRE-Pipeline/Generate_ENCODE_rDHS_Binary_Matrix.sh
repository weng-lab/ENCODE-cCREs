#!/bin/bash

# -- Kaili Fan
# Weng Lab, UMass Chan Med
# October, 2022

# This script is for generating ENCODE rDHS TF binary matrix.

workDir="/data/zusers/fankaili/ccre/ENCODE4/V3/"
scriptDir="/data/zusers/fankaili/github/weng-lab/Kaili/ccREs/ENCODE4/"

genome="GRCh38" # or mm10

rDHS_list="/data/projects/encode/Registry/V3/GRCh38/GRCh38-rDHSs.bed"
file_list="/data/zusers/fankaili/ccre/ENCODE4/V3//hg38_TF_ChIP-seq_peak_filelist2.txt"
prefix=${genome}".TF"
suffix="rDHS-V3"

cd ${workDir}
mkdir -p ${workDir}TF_matrix
cd ${workDir}TF_matrix/
mkdir tmp_${prefix}
###########
while read line
do
    expID=`awk '{print $1}' <<< ${line}`
    TF=`awk '{print $2}' <<< ${line}`
    fileID=`awk '{print $3}' <<< ${line}`
    sample=`awk '{print $5}' <<< ${line}`
    echo ${sample}
    #
    echo ${expID} > ./tmp_${prefix}/tmp.${expID}_binary.txt
    echo ${sample} >> ./tmp_${prefix}/tmp.${expID}_binary.txt
    echo ${TF} >> ./tmp_${prefix}/tmp.${expID}_binary.txt
    #
    if [ -f /data/projects/encode/data/${expID}/${fileID}.bed.gz ];then
        cp /data/projects/encode/data/${expID}/${fileID}.bed.gz ./tmp_${prefix}/
    else
        wget https://www.encodeproject.org/files/${fileID}/@@download/${fileID}.bed.gz
        mv ${fileID}.bed.gz ./tmp_${prefix}/
    fi
    #
    gzip -d ./tmp_${prefix}/${fileID}.bed.gz
    intersectBed -a ${rDHS_list} -b ./tmp_${prefix}/${fileID}.bed -wa -u > ./tmp_${prefix}/tmp.txt
    awk '{FS=OFS="\t"}{if(NR==FNR){a[$4]=1}else{if(a[$4]){print 1}else{print 0}}}' ./tmp_${prefix}/tmp.txt ${rDHS_list} >> ./tmp_${prefix}/tmp.${expID}_binary.txt
done < ${file_list}
#
echo "rDHS" > ./tmp_${prefix}/tmp.binary.txt
echo "rDHS" >> ./tmp_${prefix}/tmp.binary.txt
echo "rDHS" >> ./tmp_${prefix}/tmp.binary.txt
cut -f 4 ${rDHS_list} >> ./tmp_${prefix}/tmp.binary.txt
#
paste ./tmp_${prefix}/tmp.binary.txt ./tmp_${prefix}/tmp.*_binary.txt > ${prefix}-binary.${suffix}.txt
