#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure XX and Supplementary Table X

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

current=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
previousV2=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Simple.bed
previousV3=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-hg38/hg38-cCREs-Simple.bed

#wget BICCN-Unique-cCREs.bed

bedtools intersect -v -a BICCN-Unique-cCREs.bed -b $previousV3 | \
    bedtools intersect -v -a stdin -b $previousV2 | \
    bedtools intersect -u -b stdin -a $current > tmp.V4

group=tmp.V4
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt
sigDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output

rm -f tmp.results
for j in `seq 1 1 1325`
do
    echo $j
    d=$(awk '{if (NR == '$j') print $1"-"$2}' $list)
    bio=$(awk '{if (NR == '$j') print $3}' $list)
    x1=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $group $sigDir/$d.txt | \
	awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}') 
    x2=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres $sigDir/$d.txt | \
	awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}') 
    echo -e $d "\t" $bio "\t" $x1 "\t" $x2 >> tmp.results
done

awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' tmp.results > tmp.reformat
paste tmp.reformat tmp.metadata > Table-Input-Data/Supplementary-Table-5d.New-BICCN-DNase-Enrichment.txt

rm -f tmp.tissues
tissues=(blood brain heart kidney intestine liver lung skin)
for tissue in ${tissues[@]}
do
    echo $tissue
    grep $tissue Table-Input-Data/Supplementary-Table-5d.New-BICCN-DNase-Enrichment.txt >> tmp.tissues
done

grep -v "blood vessel" tmp.tissues | grep -v "penis" | 
    sed "s/'//g" > Figure-Input-Data/Supplementary-Figure-6a.BICCN-DNase-Enrichment.txt

rm -f tmp.*
