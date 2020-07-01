#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 6 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab

#Script that identifies cCRE tiers and filters cCREs
#Executed by 6_Filter-cCREs.sh 
#Designed to run on Slurm

dir=$1
genome=$2
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/cCRE-Pipeline
cCREs=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/$genome-cCREs-Unfiltered.bed
list=$dir/Master-Cell-List.txt
cd $dir/Concordant-Analysis

cat *.concordant.I.txt | sort -u > Concordant-Summary-I
cat *.concordant.II.txt | sort -u > Concordant-Summary-II

awk 'FNR==NR {x[$1];next} ($4 in x)' Concordant-Summary-I $cCREs > $genome-cCREs-Tier-1a.bed
awk 'FNR==NR {x[$1];next} !($1 in x)' Concordant-Summary-I Concordant-Summary-II > tmp
awk 'FNR==NR {x[$1];next} ($4 in x)' tmp $cCREs > $genome-cCREs-Tier-1b.bed

cat $genome-cCREs-Tier-1a.bed $genome-cCREs-Tier-1b.bed > $genome-cCREs-Tier-1.bed

cat *.DNase.txt | sort -u > DNase-Summary
cat *.CTCF.txt *H3K4me3.txt *H3K27ac.txt | sort -u > ChIP-Summary

python $scriptDir/summarize.class.py DNase-Summary ChIP-Summary > Class-Summary
awk 'FNR==NR {x[$4];next} !($1 in x)' $genome-cCREs-Tier-1.bed Class-Summary > \
    Nonconcordant-Summary

awk '{if (($2 == "I" && $3 == "I") || ($2 == "I" && $3 == "II") || \
    ($2 == "I" && $3 == "I.II")) print $0}' Nonconcordant-Summary > Discordant-List.txt 
awk 'FNR==NR {x[$1];next} ($4 in x)' Discordant-List.txt $cCREs > $genome-cCREs-Tier-4.bed

awk 'FNR==NR {x[$1];next} !($1 in x)' Discordant-List.txt Nonconcordant-Summary > tmp1

awk '{if ($2 == "III" && $3 == "III") print $0}' tmp1 > Class-III-List.txt
awk 'FNR==NR {x[$1];next} ($4 in x)' Class-III-List.txt $cCREs > $genome-cCREs-Tier-2.bed

awk 'FNR==NR {x[$1];next} !($1 in x)' Class-III-List.txt tmp1 > tmp2

awk '{if ($2 == "I" || $2 == "I.II" || $2 == "I.III" || $2 == "I.II.III" || \
    $3 == "I" || $3 == "I.II" || $3 == "I.III" || $3 == "I.II.III") print $0}' \
    tmp2 > no
awk 'FNR==NR {x[$1];next} !($1 in x)' no tmp2 > Potential-Tier2.txt

awk 'FNR==NR {x[$1];next} ($4 in x)' Potential-Tier2.txt $cCREs > tmp
l=$(wc -l ../Master-Cell-List.txt | awk '{print $1}')

grep PLS tmp > pls
grep DNase-H3K4me3 tmp >> pls
list=../Master-Cell-List.txt
rm -f list
for j in $(seq $l)
do
    echo $j
    group=$(awk '{if (NR == '$j') print $10}' $list)
    d1=$(awk '{if (NR == '$j') print $1}' $list)
    d2=$(awk '{if (NR == '$j') print $3}' $list)
    if [ $group == "Group2" ] || [ $group == "Group3" ] \
        || [ $group == "Group4" ]
    then
        awk 'FNR==NR {x[$4];next} ($1 in x)' pls $d1.DNase.txt \
            | awk '{if ($2 > 1.64) print $0}' >> list
        awk 'FNR==NR {x[$4];next} ($1 in x)' pls $d2.H3K4me3.txt \
        | awk '{if ($2 > 1.64) print $0}' >> list  
    fi
done
awk '{print $1}' list | sort -u > PLS-remove


grep pELS tmp > els
grep dELS tmp >> els
rm -f list
for j in $(seq $l)
do
    echo $j
    group=$(awk '{if (NR == '$j') print $10}' $list)
    d1=$(awk '{if (NR == '$j') print $1}' $list)
    d2=$(awk '{if (NR == '$j') print $5}' $list)
    if [ $group == "Group2" ] || [ $group == "Group5" ] \
        || [ $group == "Group14" ]
    then
        awk 'FNR==NR {x[$4];next} ($1 in x)' els $d1.DNase.txt \
            | awk '{if ($2 > 1.64) print $0}' >> list
        awk 'FNR==NR {x[$4];next} ($1 in x)' els $d2.H3K27ac.txt \
        | awk '{if ($2 > 1.64) print $0}' >> list  
    fi
done
awk '{print $1}' list | sort -u > ELS-remove

grep CTCF tmp > ctcf
rm -f list
for j in $(seq $l)
do
    echo $j
    group=$(awk '{if (NR == '$j') print $10}' $list)
    d1=$(awk '{if (NR == '$j') print $1}' $list)
    d2=$(awk '{if (NR == '$j') print $7}' $list)
    if [ $group == "Group3" ] || [ $group == "Group6" ] \
        || [ $group == "Group14" ]
    then
        awk 'FNR==NR {x[$4];next} ($1 in x)' ctcf $d1.DNase.txt \
            | awk '{if ($2 > 1.64) print $0}' >> list
        awk 'FNR==NR {x[$4];next} ($1 in x)' ctcf $d2.CTCF.txt \
        | awk '{if ($2 > 1.64) print $0}' >> list  
    fi
done
awk '{print $1}' list | sort -u > CTCF-remove

cat *-remove | sort -u > tier3-failed-pertinent-data.txt

awk 'FNR==NR {x[$1];next} !($1 in x)' tier3-failed-pertinent-data.txt \
    Potential-Tier2.txt > tier2-passed-pertinent-data.txt

awk 'FNR==NR {x[$1];next} ($4 in x)' tier2-passed-pertinent-data.txt \
    $cCREs >> $genome-cCREs-Tier-2.bed

awk 'FNR==NR {x[$1];next} ($4 in x)' tier3-failed-pertinent-data.txt $cCREs > \
    $genome-cCREs-Tier-3.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' no $cCREs >> $genome-cCREs-Tier-3.bed

cat $genome-cCREs-Tier-1a.bed $genome-cCREs-Tier-1b.bed $genome-cCREs-Tier-2.bed \
    > ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/$genome-cCREs-Simple.bed
