#!/bin/bash

#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024
#Step 2 - Create rDHSs

genome=$1
dir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/$genome-rDHS
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Pipeline/Toolkit
altiusList=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/$genome-cDHS/Altius-cDHSs.DAC-$genome.bed

cd $dir/Processed-DHSs

echo -e "Combining DHSs..."
cat output.* > tmp
mv tmp $dir/$genome-DHS-All.bed

if [ $genome == "mm10" ]
then
cutoff=0.203923 #cutoff 10% of 10,000,000 randomly selected DHSs
elif [ $genome == "hg38" ]
then
cutoff=0.145873 #cutoff 10% of 10,000,000 randomly selected DHSs
fi

echo -e "Filtering DHSs..."
cd $dir
awk '{if ($1 !~ /_/ && $3-$2 >= 150 && $6 >= '$cutoff' && $5 <= 0.001) print $0}' \
    $genome-DHS-All.bed | grep -v "chrEBV" | grep -v "chrM" > $genome-DHS-Filtered.bed

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
    bedtools merge -i sorted -c 4,6 -o collapse,collapse > merge
    python $scriptDir/pick-best-peak.py merge > peak-list
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
    previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/V1-V2-V3.rDHS-mm10.bed
elif [[ $genome == "hg38" ]]
then
    previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/V1-V2-V3.rDHS-hg38.bed
fi

echo -e "Accessioning rDHSs..."
sort -k1,1 -k2,2n tmp.bed > sorted.bed
python $scriptDir/make-region-accession.py sorted.bed $genome rDHS $previous > zz

bedtools intersect -F 1 -u -a zz -b $altiusList > completeCoverage.bed
bedtools intersect -F 1 -v -a zz -b $altiusList > tmp
bedtools intersect -v -a tmp -b $altiusList > NoCoverage.bed
bedtools intersect -wo -a tmp -b $altiusList > partialCoverage.bed

awk '{if ($NF >= 135) {out=$1; for(i=2;i<=7;i++){out=out"\t"$i}; print out}}' \
    partialCoverage.bed | sort -u > 135Coverage.bed
awk 'FNR==NR {x[$4];next} !($4 in x)' 135Coverage.bed partialCoverage.bed | \
    awk '{out=$1; for(i=2;i<=7;i++){out=out"\t"$i}; print out}' > LessCoverage.bed

python $scriptDir/calculate-cdhs-percentile.py NoCoverage.bed > percentile.txt
j=90

n=$(awk '{if (NR == '$j') print $2}' percentile.txt)
awk '{if ($6 >= '$n') print $0}' LessCoverage.bed | sort -u > working.bed
cat 135Coverage.bed completeCoverage.bed >> working.bed

mv working.bed $genome-rDHS-Filtered-Summary.txt
awk '{print $1 "\t" $2 "\t" $3 "\t" $NF}' $genome-rDHS-Filtered-Summary.txt \
    > $genome-rDHS-Filtered.bed

mv zz $genome-rDHS-PreAltius.txt

rm sorted.bed
rm tmp.bed partialCoverage.bed
rm percentile.txt LessCoverage.bed 135Coverage.bed

