#!/bin/bash
#Jill E Moore
#Moore Lab
#UMass Chan Medical School


source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

wget https://fantom.gsc.riken.jp/5/datafiles/reprocessed/hg38_latest/extra/CAGE_peaks/hg38_fair+new_CAGE_peaks_phase1and2.bed.gz
gunzip hg38_fair+new_CAGE_peaks_phase1and2.bed.gz

sort -k1,1 -k2,2n hg38_fair+new_CAGE_peaks_phase1and2.bed | bedtools closest -d -a stdin -b ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed | awk '{if ($NF < 250) sum +=1}END{print "CAGE" "\t" sum "\t" NR "\t" sum/NR}' > Table-Input-Data/Supplementary-Table-2.TSS-Overlap.txt

rampage=~/Lab/ENCODE/RAMPAGE/hg38-rPeaks.TSS.bed
sort -k1,1 -k2,2n $rampage | bedtools closest -d -a stdin -b ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed | awk '{if ($NF < 250) sum +=1}END{print "RAMPAGE" "\t" sum "\t" NR "\t" sum/NR}' >> Table-Input-Data/Supplementary-Table-2.TSS-Overlap.txt


rm hg38_fair+new_CAGE_peaks_phase1and2.bed
