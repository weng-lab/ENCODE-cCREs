#!/bin/bash

ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-rDHS/hg38-rDHS-Filtered.bed
tfList=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Input-Lists/Low-Overlap.Sequence-Specific-TF-Experiments.txt
outputDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Anchor-TF-Overlap/Low-Overlap

mkdir -p $outputDir
cd $outputDir

#for i in `seq 1 1 50`
#do
#    d1=$(awk '{if (NR == '$i') print $4}' $tfList)
#    d2=$(awk '{if (NR == '$i') print $5}' $tfList)
#
#    cp /data/projects/encode/data/$d1/$d2.bed.gz bed.gz
#    gunzip bed.gz
#
#    bedtools intersect -v -a bed -b $ccres > $d1.NocCREs.bed
#    rm bed
#done

awk 'BEGIN{print "experiment-tf"}{print $4"-"$3}' $tfList > tmp.matrix 

for i in `seq 1 1 50`
do
    echo $i
    exp1=$(awk '{if (NR == '$i') print $4}' $tfList)
    echo $exp1 > tmp.col
    for j in `seq 1 1 50`
    do
	echo -e "\t" $j
        exp2=$(awk '{if (NR == '$j') print $4}' $tfList)

	bedtools intersect -c -a $exp1.NocCREs.bed -b $exp2.NocCREs.bed | \
	    awk '{if ($NF > 0) sum += 1}END{print sum/NR}' >> tmp.col
    done
    paste tmp.matrix tmp.col > tmp.tmp
    mv tmp.tmp tmp.matrix
done

mv tmp.matrix ../../Figure-Input-Data/Supplementary-Figure-1b.TF-Overlap-Matrix.txt
