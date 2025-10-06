
#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 1ef

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
bigWig=~/Lab/Reference/Human/hg38/Conservation/hg38.phastCons100way.bw
rdhs=../../hg38-rDHS-Filtered.bed

cd $workingDir

#wget
#gunzip
tfClusters=GRCh38-TF-Clusters-All.txt

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $tfClusters | sort -k4,4 > tmp.bed
~/bin/bigWigAverageOverBed $bigWig tmp.bed tmp.out

cd $workingDir

sort -k4,4 $tfClusters > tmp.1
sort -k1,1 tmp.out > tmp.2
paste tmp.1 tmp.2 > tmp.3

bedtools intersect -u -a tmp.3 -b $rdhs | awk '{print $0 "\t" "overlap"}' > tmp.2
bedtools intersect -v -a tmp.3 -b $rdhs | awk '{print $0 "\t" "no-overlap"}' >> tmp.2

awk -F "\t" '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $8 "\t" $9 "\t" $14 "\t" $NF}' tmp.2 > \
    Figure-Input-Data/Supplementary-Figure-1f.TF-Anchor-Support.txt

rm -f tmp.summary
data=Figure-Input-Data/Supplementary-Figure-1f.TF-Anchor-Support.txt
for j in `seq 1 1 19`
do
    echo $j
    awk '{if ($5 == '$j') sum +=1}END{print "'$j'" "\t" sum}' $data >> tmp.summary
done
awk '{if ($5 >= 20) sum +=1}END{print "20+" "\t" sum}' $data >> tmp.summary
mv tmp.summary Figure-Input-Data/Supplementary-Figure-1e.TF-Anchor-Support.txt


rm tmp.*
