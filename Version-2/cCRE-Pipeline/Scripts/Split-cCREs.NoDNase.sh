#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

files=$1
j=$2
genome=$3

mkdir -p /tmp/moorej3/$SLURM_JOBID
cd /tmp/moorej3/$SLURM_JOBID
bedtools=~/bin/bedtools2/bin/bedtools

if [[ $genome == "mm10" ]]
then
prox=~/Lab/Reference/Mouse/GENCODEM18/TSS.Basic.4K.bed
tss=~/Lab/Reference/Mouse/GENCODEM18/TSS.Basic.bed
ChromInfo=~/Lab/Reference/Mouse/ChromInfo.txt
elif [[ $genome == "hg38" ]]
then
prox=~/Lab/Reference/Human/$genome/GENCODE24/TSS.Basic.4K.bed
tss=~/Lab/Reference/Human/$genome/GENCODE24/TSS.Basic.bed
ChromInfo=~/Lab/Reference/Human/hg38/chromInfo.txt
fi

scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline
master=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/$genome-ccREs-Simple.bed
output=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific/Seven-Group
cresAS=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific/cres.as

dir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/signal-output

cp $master bed

A=$(awk -F "\t" '{if (NR == '$j') print $3}' $files)
B=$(awk -F "\t" '{if (NR == '$j') print $4}' $files)
if [[ $A == "---" ]]
then
    H3K4me3=$dir/blank.txt
else
    H3K4me3=$dir/$A"-"$B.txt
fi

A=$(awk -F "\t" '{if (NR == '$j') print $5}' $files)
B=$(awk -F "\t" '{if (NR == '$j') print $6}' $files)
if [[ $A == "---" ]]
then
    H3K27ac=$dir/blank.txt
else
    H3K27ac=$dir/$A"-"$B.txt    
fi

A=$(awk -F "\t" '{if (NR == '$j') print $7}' $files)
B=$(awk -F "\t" '{if (NR == '$j') print $8}' $files)
if [[ $A == "---" ]]
then
    CTCF=$dir/blank.txt
else
    CTCF=$dir/$A"-"$B.txt
fi

accession=$(cat $files | awk -F "\t" '{if (NR == '$j') print $4"_"$6"_"$8}' \
    | awk '{gsub(/_---/,"");print}' | awk '{gsub(/---_/,"");print}')
biosample=$(cat $files | awk -F "\t" '{if (NR == '$j') print $9}')

$bedtools intersect -u -a bed -b $tss > tss
$bedtools intersect -v -a bed -b $tss > a1
$bedtools intersect -u -a a1 -b $prox | sort -k1,1 -k2,2n > prox
$bedtools intersect -v -a bed -b $prox > distal

$bedtools closest -d -a prox -b $tss > tmp
python $scriptDir/calculate-center-distance.py tmp specific > new
awk '{if ($2 >= -200 && $2 <= 200) print $0}' new > center-distance
awk '{if ($2 < -2000 || $2 > 2000) print $0}' new > far
awk 'FNR==NR {x[$1];next} ($4 in x)' center-distance prox >> tss
awk 'FNR==NR {x[$1];next} ($4 in x)' far prox >> distal
cat center-distance far > new
awk 'FNR==NR {x[$1];next} !($4 in x)' new prox > tmp
mv tmp prox
rm new

###TSS elements###
awk 'FNR==NR {x[$4];next} ($1 in x)' tss $H3K4me3 | \
    awk '{if ($2 > 1.64) print $0}' > red
awk 'FNR==NR {x[$4];next} ($1 in x)' tss $H3K4me3 | \
    awk '{if ($2 <= 1.64) print $0}' > no1
check=$(wc -l no1 | awk '{print $1}')
if [[ $check -eq 0 ]]
then
    awk '{print $4}' tss > no1
fi
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $H3K27ac | \
    awk '{if ($2 > 1.64) print $0}' > orange
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $H3K27ac | \
    awk '{if ($2 <= 1.64) print $0}' > no2
check=$(wc -l no2 | awk '{print $1}')
if [[ $check -eq 0 ]]
then
    cp no1 no2
fi

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $CTCF | \
    awk '{if ($2 > 1.64) print $0}' > blue

###Proximal elements###
awk 'FNR==NR {x[$4];next} ($1 in x)' prox $H3K27ac | \
    awk '{if ($2 > 1.64) print $0}' >> orange
awk 'FNR==NR {x[$4];next} ($1 in x)' prox $H3K27ac | \
    awk '{if ($2 <= 1.64) print $0}' > no1
check=$(wc -l no1 | awk '{print $1}')
if [[ $check -eq 0 ]]
then
    awk '{print $4}' prox > no1
fi
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $H3K4me3 | \
    awk '{if ($2 > 1.64) print $0}' > pink
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $H3K4me3 | \
    awk '{if ($2 <= 1.64) print $0}' > no2
check=$(wc -l no2 | awk '{print $1}')
if [[ $check -eq 0 ]]
then
    cp no1 no2
fi
awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $CTCF | \
    awk '{if ($2 > 1.64) print $0}' >> blue

###Distal elements###
awk 'FNR==NR {x[$4];next} ($1 in x)' distal $H3K27ac | \
    awk '{if ($2 > 1.64) print $0}' >> orange
awk 'FNR==NR {x[$4];next} ($1 in x)' distal $H3K27ac | \
    awk '{if ($2 <= 1.64) print $0}' > no1
check=$(wc -l no1 | awk '{print $1}')
if [[ $check -eq 0 ]]
then
    awk '{print $4}' distal > no1
fi
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $H3K4me3 | \
    awk '{if ($2 > 1.64) print $0}' >> pink
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $H3K4me3 | \
    awk '{if ($2 <= 1.64) print $0}' > no2
check=$(wc -l no2 | awk '{print $1}')
if [[ $check -eq 0 ]]
then
    cp no1 no2
fi
awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $CTCF | \
    awk '{if ($2 > 1.64) print $0}' >> blue

cat red orange pink blue > all.txt

awk 'FNR==NR {x[$1];next} ($4 in x)' blue $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "0,176,240" "\t""*"}' > l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' pink $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "255,170,170" "\t""*"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' orange $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "255,205,0" "\t""*"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' red $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "255,0,0" "\t" "*"}' >> l.bed

if [[ $H3K4me3 != "$dir/blank.txt" ]]
then
    awk 'FNR==NR {x[$1];next} ($1 in x)' l.bed $H3K4me3 | awk '{if ($2 > 1.64) \
        print $0}' > Sigall
    awk -F "\t" 'FNR==NR {x[$1];next} ($1 in x)' Sigall l.bed | \
        awk '{print $0 "High-H3K4me3,"}' > m.bed
    awk -F "\t"  'FNR==NR {x[$1];next} !($1 in x)' Sigall l.bed | \
        awk '{print $0}' >> m.bed
    sort -k1,1 -k2,2n m.bed > l.bed 
else
    cat l.bed > m.bed
    sort -k1,1 -k2,2n m.bed > l.bed
fi


if [[ $H3K27ac != "$dir/blank.txt" ]]
then
    awk 'FNR==NR {x[$1];next} ($1 in x)' l.bed $H3K27ac | awk '{if ($2 > 1.64) \
        print $0}' > Sigall
    awk -F "\t" 'FNR==NR {x[$1];next} ($1 in x)' Sigall l.bed | \
        awk '{print $0 "High-H3K27ac,"}' > m.bed
    awk -F "\t"  'FNR==NR {x[$1];next} !($1 in x)' Sigall l.bed | \
        awk '{print $0}' >> m.bed
    sort -k1,1 -k2,2n m.bed > l.bed 
else
    cat l.bed > m.bed
    sort -k1,1 -k2,2n m.bed > l.bed
fi


if [[ $CTCF != "$dir/blank.txt" ]]
then
    awk 'FNR==NR {x[$1];next} ($1 in x)' l.bed $CTCF | awk '{if ($2 > 1.64) \
        print $0}' > Sigall
    awk -F "\t" 'FNR==NR {x[$1];next} ($1 in x)' Sigall l.bed | \
        awk '{print $0 "High-CTCF,"}' > m.bed
    awk -F "\t"  'FNR==NR {x[$1];next} !($1 in x)' Sigall l.bed | \
        awk '{print $0}' >> m.bed
    sort -k1,1 -k2,2n m.bed > l.bed 
else
    cat l.bed > m.bed
    sort -k1,1 -k2,2n m.bed > l.bed
fi

awk '{gsub(/,$/,""); print}' l.bed | awk '{gsub(/*/,""); print}' | \
    awk '{printf "%s", $2; for(i=3;i<=NF;i+=1) printf "\t%s",$i; print ""}' > m.bed 


awk 'FNR==NR {x[$4];next} !($5 in x)' m.bed $master \
         | awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "140,140,140" "\t" "Unclassified"}' > p.bed

cat m.bed p.bed | sort -k1,1 -k2,2n | awk '{print $0 "\t" \
        "Missing-data/Partial-classification"}' > $accession".7group.bed"

~/bin/bedToBigBed -type=bed9+2 -as=$cresAS $accession".7group.bed"\
    $ChromInfo $accession".7group.bigBed"
mv $accession".7group.bed" $accession".7group.bigBed" $output

cd
rm -r /tmp/moorej3/$SLURM_JOBID
