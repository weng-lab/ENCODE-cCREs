#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 10aei

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization/cCRE-Enrichment
ccreAll=../../../hg38-cCREs-Unfiltered.bed
ccreK562=K562-cCREs.bed

cd $workingDir

echo -e "Method" "\t" "K562-cCRE" "\t" "All-cCRE" "\t" "No-cCRE" > tmp.out

###MPRA
#wget https://www.encodeproject.org/files/ENCFF677CJZ/@@download/ENCFF677CJZ.bed.gz
#gunzip ENCFF677CJZ.bed.gz

mpra=ENCFF677CJZ.bed
awk '{if ($7 > 1) print $0}' $mpra > tmp.positive
regions=tmp.positive

k562Total=$(bedtools intersect -u -a $regions -b $ccreK562 | wc -l | awk '{print $1}')
ccreTotal=$(bedtools intersect -u -a $regions -b $ccreAll | wc -l | awk '{print $1}')
none=$(bedtools intersect -v -a $regions -b $ccreAll | wc -l | awk '{print $1}')

awk 'BEGIN{print "MPRA" "\t" '$k562Total' "\t" '$ccreTotal'-'$k562Total' "\t" '$none'}' >> tmp.out

###STARR-seq
#wget https://www.encodeproject.org/files/ENCFF454ZKK/@@download/ENCFF454ZKK.bed.gz
#gunzip ENCFF454ZKK.bed.gz

regions=ENCFF454ZKK.bed

k562Total=$(bedtools intersect -F 0.5 -u -a $regions -b $ccreK562 | wc -l | awk '{print $1}')
ccreTotal=$(bedtools intersect -F 0.5 -u -a $regions -b $ccreAll | wc -l | awk '{print $1}')
none=$(bedtools intersect -F 0.5 -v -a $regions -b $ccreAll | wc -l | awk '{print $1}')

awk 'BEGIN{print "STARR" "\t" '$k562Total' "\t" '$ccreTotal'-'$k562Total' "\t" '$none'}' >> tmp.out

###CRISPR

#wget https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/Reilly-Tewhey.41588_2021_900_MOESM3_ESM.Table-3.bed.gz
#gunzip Reilly-Tewhey.41588_2021_900_MOESM3_ESM.Table-3.bed.gz
regions=Reilly-Tewhey.41588_2021_900_MOESM3_ESM.Table-3.bed

k562Total=$(bedtools intersect -u -a $regions -b $ccreK562 | wc -l | awk '{print $1}')
ccreTotal=$(bedtools intersect -u -a $regions -b $ccreAll | wc -l | awk '{print $1}')
none=$(bedtools intersect -v -a $regions -b $ccreAll | wc -l | awk '{print $1}')

awk 'B EGIN{print "CRISPR" "\t" '$k562Total' "\t" '$ccreTotal'-'$k562Total' "\t" '$none'}' >> tmp.out

mv tmp.out ../Figure-Input-Data/Supplementary-Figure-10aei.FCC-Positive-Overlap.txt


