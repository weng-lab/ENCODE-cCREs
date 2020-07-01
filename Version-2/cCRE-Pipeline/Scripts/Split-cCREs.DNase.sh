#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 7 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab

#Script assigns group classifications to cCREs
#in biosamples with DNase
#Executed by 7_Cell-Type-Specific-Seven-Group.sh
#Designed to run on Slurm

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

scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/cCRE-Pipeline
master=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/$genome-cCREs-Simple.bed
output=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific/Seven-Group
cresAS=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific/cres.as

dir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/signal-output
A=$(awk -F "\t" '{if (NR == '$j') print $1}' $files)
B=$(awk -F "\t" '{if (NR == '$j') print $2}' $files)
DNase=$dir/$A"-"$B.txt

awk '{if ($2 > 1.64) print $0}' $DNase > list
awk 'FNR==NR {x[$1];next} ($4 in x)' list $master > bed

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

accession=$(cat $files | awk -F "\t" '{if (NR == '$j') print $2"_"$4"_"$6"_"$8}' \
    | awk '{gsub(/_---/,"");print}')
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

awk '{if ($2 > 1.64) print $0}' $H3K4me3 > highH3K4me3
awk '{if ($2 > 1.64) print $0}' $CTCF > highCTCF
awk '{if ($2 > 1.64) print $0}' $H3K27ac > highH3K27ac


###TSS elements###
awk 'FNR==NR {x[$1];next} ($4 in x)' highH3K4me3 tss | \
    awk '{print $4}' > PLS
awk 'FNR==NR {x[$1];next} !($4 in x)' highH3K4me3 tss | \
    awk '{print $4}' > no1
awk 'FNR==NR {x[$1];next} ($1 in x)' highH3K27ac no1 | \
    awk '{print $1}' > pELS
awk 'FNR==NR {x[$1];next} !($1 in x)' highH3K27ac no1 | \
    awk '{print $1}' > no2
awk 'FNR==NR {x[$1];next} ($1 in x)' highCTCF no2  | \
    awk '{print $1}' > CTCFonly

###Proximal elements###
awk 'FNR==NR {x[$1];next} ($4 in x)' highH3K27ac prox | \
    awk '{print $4}' >> pELS
awk 'FNR==NR {x[$1];next} !($4 in x)' highH3K27ac prox | \
    awk '{print $4}' > no1
awk 'FNR==NR {x[$1];next} ($1 in x)' highH3K4me3 no1 | \
    awk '{print $1}' >> DNaseK4
awk 'FNR==NR {x[$1];next} !($1 in x)' highH3K4me3 no1 | \
    awk '{print $1}' > no2
awk 'FNR==NR {x[$1];next} ($1 in x)' highCTCF no2  | \
    awk '{print $1}' >> CTCFonly

###Distal elements###
awk 'FNR==NR {x[$1];next} ($4 in x)' highH3K27ac distal | \
    awk '{print $4}' > dELS
awk 'FNR==NR {x[$1];next} !($4 in x)' highH3K27ac distal | \
    awk '{print $4}' > no1
awk 'FNR==NR {x[$1];next} ($1 in x)' highH3K4me3 no1 | \
    awk '{print $1}' >> DNaseK4
awk 'FNR==NR {x[$1];next} !($1 in x)' highH3K4me3 no1 | \
    awk '{print $1}' > no2
awk 'FNR==NR {x[$1];next} ($1 in x)' highCTCF no2  | \
    awk '{print $1}' >> CTCFonly
    

cat PLS pELS dELS DNaseK4 CTCFonly > all.txt
check=$(wc -l all.txt | awk '{print $1}')

if [[ $check == "0" ]]
then
    echo "done" >> all.txt
fi

awk 'FNR==NR {x[$1];next} !($1 in x)' all.txt list > DNaseonly

awk 'FNR==NR {x[$1];next} ($4 in x)' CTCFonly $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "0,176,240" "\t" "CTCF-only"}' > l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' dELS $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "255,205,0" "\t" "dELS"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' pELS $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "255,167,0" "\t" "pELS"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' PLS $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "255,0,0" "\t" "PLS"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' DNaseK4 $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "255,170,170" "\t" "DNase-H3K4me3"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' DNaseonly $master \
         | awk '{print $4 "\t" $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "6,218,147" "\t" "DNase-only"}' >> l.bed

if [[ $CTCF != "$dir/blank.txt" ]]
then
    awk 'FNR==NR {x[$1];next} ($1 in x)' l.bed $CTCF | awk '{if ($2 > 1.64) \
        print $0}' > CTCFall
    awk 'FNR==NR {x[$1];next} ($1 in x)' CTCFall l.bed | awk '{printf "%s", \
        $2; for(i=3;i<=NF;i+=1) printf "\t%s",$i; print ",CTCF-bound"}' > m.bed
    awk 'FNR==NR {x[$1];next} !($1 in x)' CTCFall l.bed | awk '{printf "%s", \
        $2; for(i=3;i<=NF;i+=1) printf "\t%s",$i; print ""}' >> m.bed
    sort -k1,1 -k2,2n m.bed > l.bed 
else
    awk '{printf "%s", $2; for(i=3;i<=NF;i+=1) printf "\t%s",$i; print ""}' \
        l.bed > m.bed
    sort -k1,1 -k2,2n m.bed > l.bed

fi

awk 'FNR==NR {x[$4];next} !($5 in x)' l.bed $master \
         | awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" 0 "\t" "." "\t" $2 \
         "\t" $3 "\t" "225,225,225" "\t" "Low-DNase"}' > p.bed

if [ $H3K4me3 == "$dir/blank.txt" ] || [ $H3K27ac == "$dir/blank.txt" ] || \
    [ $CTCF == "$dir/blank.txt" ]
then
    cat l.bed p.bed | sort -k1,1 -k2,2n | awk '{print $0 "\t" \
        "Missing-data/Partial-classification"}' > $accession".7group.bed"
else
    cat l.bed p.bed | sort -k1,1 -k2,2n | awk '{print $0 "\t" \
        "All-data/Full-classification"}' > $accession".7group.bed"
fi

~/bin/bedToBigBed -type=bed9+2 -as=$cresAS $accession".7group.bed"\
    $ChromInfo $accession".7group.bigBed"
mv $accession".7group.bed" $accession".7group.bigBed" $output

cd
rm -r /tmp/moorej3/$SLURM_JOBID
