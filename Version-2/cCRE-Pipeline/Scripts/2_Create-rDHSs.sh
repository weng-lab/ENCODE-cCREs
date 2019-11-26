#!/bin/bash

#Step 2 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab
#November 2019

#TO RUN:
#./2_Create-rDHSs.sh {genome: hg38, mm10}

genome=$1
dir=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/
scriptDir=/home/moorej3/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline
stamList=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/$genome-Stam-cDHS-All.bed

cd $dir/Processed-DHSs

echo -e "Combining DHSs..."
cat output.* > tmp
mv tmp $dir/$genome-DHS-All.bed

if [ $genome == "mm10" ]
then
cutoff=0.1454
elif [ $genome == "hg38" ]
then
cutoff=0.1508
fi

echo -e "Filtering DHSs..."
cd $dir
awk '{if ($1 !~ /_/ && $3-$2 >= 150 && $5 >= '$cutoff' && $9 <= 0.001) print $0}' \
    $genome-DHS-All.bed | grep -v "chrEBV" | grep -v "chrM" > $genome-DHS-Filtered.bed
#0.1508 is 10th percentile of signal for 100k randomly selected DHSs

mkdir scratch
cp $genome-DHS-Filtered.bed scratch/tmp.bed
cd scratch

echo -e "Sorting DHSs..."
sort -k1,1 -k2,2n tmp.bed > sorted
rm -f rPeaks
num=$(wc -l sorted | awk '{print $1}')

echo -e "Merging DHSs..."
while [ $num -gt 0 ]
do
    echo -e "\t" $num
    bedtools merge -i sorted -c 4,5 -o collapse,collapse > merge
    python $scriptDir/pick.best.peak.py merge > peak-list
    awk 'FNR==NR {x[$1];next} ($4 in x)' peak-list sorted >> rPeaks
    bedtools intersect -v -a sorted -b rPeaks > remaining
    mv remaining sorted
    num=$(wc -l sorted | awk '{print $1}')
done

mv rPeaks ../tmp.bed
cd ../
rm -r scratch

if [[ $genome == "mm10" ]]
then
previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/rDHS.mm10.bed
elif [[ $genome == "hg38" ]]
then
previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/rDHS.hg19-hg38.bed
elif [[ $genome == "hg19" ]]
then
previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/rDHS.hg19.bed
fi

echo -e "Accessioning rDHSs..."
sort -k1,1 -k2,2n tmp.bed > sorted.bed
python $scriptDir/make.region.accession.py sorted.bed $genome rDHS $previous > zz

bedtools intersect -F 1 -u -a zz -b $stamList > completeCoverage.bed
bedtools intersect -F 1 -v -a zz -b $stamList > tmp
bedtools intersect -v -a tmp -b $stamList > NoCoverage.bed
bedtools intersect -wo -a tmp -b $stamList > partialCoverage.bed

awk '{if ($NF >= 135) {out=$1; for(i=2;i<=10;i++){out=out"\t"$i}; print out}}' \
    partialCoverage.bed | sort -u > 135Coverage.bed
awk 'FNR==NR {x[$4];next} !($4 in x)' 135Coverage.bed partialCoverage.bed | \
    awk '{out=$1; for(i=2;i<=10;i++){out=out"\t"$i}; print out}' > LessCoverage.bed

python $scriptDir/percentile.py NoCoverage.bed > percentile.txt
j=90

n=$(awk '{if (NR == '$j') print $2}' percentile.txt)
awk '{if ($5 >= '$n') print $0}' LessCoverage.bed | sort -u > working.bed
cat 135Coverage.bed completeCoverage.bed >> working.bed

mv working.bed $genome-rDHS-Filtered-Summary.txt
awk '{print $1 "\t" $2 "\t" $3 "\t" $10}' $genome-rDHS-Filtered-Summary.txt \
    > $genome-rDHS-Filtered.bed

mv zz $genome-rDHS-PreStam.txt

rm sorted.bed
rm tmp.bed partialCoverage.bed
rm percentile.txt LessCoverage.bed 135Coverage.bed

