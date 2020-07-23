#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#./Supplementary-Figure-1ab.Evaluate-VISTA-Enhancers.sh {tissue} {peakMethod} {signalMethod}

tissue=$1
peakMethod=$2
signalMethod=$3
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
inputDataDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Input-Data/mm10
vistaRegions=$inputDataDir/VISTA-Evaluation-Regions.txt
fileMatrix=$inputDataDir/VISTA-Data-Matrix.txt

col1=$(head -n 1 $vistaRegions | tr '\t' '\n' | grep -n $tissue | \
    awk -F ":" '{print $1}')
awk '{if (NR > 1) print $1 "\t" $2 "\t" $3 "\t" $'$col1'}' $vistaRegions > tmp.vista

col2=$(head -n 1 $fileMatrix | tr '\t' '\n' | grep -n $signalMethod"-Exp" | \
    awk -F ":" '{print $1}')
sig=$(grep $tissue $fileMatrix | awk '{print $'$col2'"/"$('$col2'+2)".bigWig"}')
signal=/data/projects/encode/data/$sig
peak=$(grep $tissue $fileMatrix | awk '{print $'$col2'"/"$('$col2'+1)".bed.gz"}')
peaks=/data/projects/encode/data/$peak
cp $peaks bed.gz 
gunzip bed.gz


if [ $signalMethod == "DNase" ]
then
    width=250
else
    width=1000
fi

if [ $peakMethod == "DNase" ]
then
    awk -F "\t" '{printf "%s\t%.0f\t%.0f\t%s\n", $1,($3+$2)/2-'$width',\
    ($3+$2)/2+'$width',$4}' bed | awk '{if ($2 < 0) print $1 "\t" 0 \
    "\t" $3 "\t" $4 ; else print $0}' > tmp.bed
else
    awk '{print $1 "\t" $2+$10-'$width' "\t" $2+$10+'$width' "\t" $4}' \
    bed > tmp.bed
fi

~/bin/bigWigAverageOverBed $signal tmp.bed out.tab -bedOut=out.bed

awk '{if ($2 > 0) print $1 "\t" $2+'$width'-150 "\t" $3-'$width'+150 "\t" $4 "\t" $5;\
    else printf "%s\t%.0f\t%.0f\t%s\t%s\n", $1,($3+$2)/2-150,($3+$2)/2+150,$4,$5}' out.bed \
    | awk '{if ($2 < 0) print $1 "\t" 0 "\t" $3 "\t" $4 "\t" $5; else print $0}' \
    | sort -k5,5rg > tmp.signal

bedtools intersect -wo -a tmp.vista -b tmp.signal > tmp.intersect
python $scriptDir/select-one-peak.py tmp.intersect 9 | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $9}' \
    >  tmp.results

bedtools intersect -v -a tmp.vista -b tmp.signal | awk '{print $1 "\t" $2 "\t" $3 \
    "\t" $4 "\t" 0 }' >> tmp.results

mv tmp.results $tissue-$signalMethod-$peakMethod.Results.txt
rm tmp* bed
