#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 5ab

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

current=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
previous=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Simple.bed
previousFull=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Unfiltered.bed
G1=V2-V4.Replicated
G2=V2-V4.Filtered
G3=V2-V4.New

bedtools intersect -u -a $current -b $previous > tmp.same
bedtools intersect -v -a $current -b $previous | \
    bedtools intersect -u -a stdin -b $previousFull > tmp.filtered
bedtools intersect -v -a $current -b $previous | \
    bedtools intersect -v -a stdin -b $previousFull > tmp.new

wc -l tmp.same | awk '{print "'$G1'" "\t" $1}' > tmp.results
wc -l tmp.filtered | awk '{print "'$G2'" "\t" $1}' >> tmp.results
wc -l tmp.new | awk '{print "'$G3'" "\t"  $1}' >> tmp.results

mv tmp.results Figure-Input-Data/Supplementary-Figure-5a.Previous-Version-Comparison.txt

mv tmp.same $G1.bed
mv tmp.filtered $G2.bed
mv tmp.new $G3.bed

#bedtools shuffle -i $current -g ~/Lab/Reference/Human/hg38/chromInfo.txt -excl $current > Background.No-cCREs.bed
background=Background.No-cCREs.bed

wget https://www.encodeproject.org/files/ENCFF908UFR/@@download/ENCFF908UFR.bed.gz
gunzip ENCFF908UFR.bed.gz

starrRegions=ENCFF908UFR.bed
bedtools intersect -c -a $G1.bed -b $starrRegions | \
	    awk '{if ($NF > 0) sum += 1}END{print "'$G1'" "\t" sum/NR*100 "\t" sum "\t" NR}' > tmp.results
bedtools intersect -c -a $G2.bed -b $starrRegions | \
	    awk '{if ($NF > 0) sum += 1}END{print "'$G2'" "\t" sum/NR*100 "\t" sum "\t" NR}' >> tmp.results
bedtools intersect -c -a $G3.bed -b $starrRegions | \
	    awk '{if ($NF > 0) sum += 1}END{print "'$G3'" "\t" sum/NR*100 "\t" sum "\t" NR}' >> tmp.results
bedtools intersect -c -a $background -b $starrRegions | \
	    awk '{if ($NF > 0) sum += 1}END{print "Non-cCRE" "\t" sum/NR*100 "\t" sum "\t" NR}' >> tmp.results

mv tmp.results Figure-Input-Data/Supplementary-Figure-5b.STARR-Overlap-Version-Comparison.txt
rm $starrRegions

