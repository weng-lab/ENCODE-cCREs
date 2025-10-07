#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 20b and Supplementary Table 13g

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/4_MAFF-MAFK
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit

cd $workingDir

grep dELS K562-MAFF-MAFK.K562.bed > tmp.yes-maff
grep dELS ../../Cell-Type-Specific/Individual-Files/ENCFF414OGC_ENCFF806YEZ_ENCFF849TDM_ENCFF736UDR.bed | awk 'FNR==NR {x[$4];next} !($4 in x)' tmp.yes-maff - > tmp.no-maff

rm -f tmp.tf
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-TF/hg38-TF-List.Filtered-K562.txt
k=$(wc -l $list | awk '{print $1}')
for i in `seq 1 1 $k`
do

    echo $i
    d1=$(awk '{if (NR == '$i') print $1}' $list)
    d2=$(awk '{if (NR == '$i') print $2}' $list)
    tf=$(awk -F "\t" '{if (NR == '$i') print $4}' $list)
    cp /data/projects/encode/data/$d1/$d2.bed.gz bed.gz
    gunzip bed.gz
    awk '{print $1 "\t" $2+$10-1 "\t" $2+$10}' bed > tmp

    maff=$(bedtools intersect -u -a tmp.yes-maff -b tmp | wc -l | awk '{print $1}')
    nomaff=$(bedtools intersect -u -a tmp.no-maff -b tmp | wc -l | awk '{print $1}')
    tmaff=$(wc -l tmp.yes-maff | awk '{print $1}')
    tnomaff=$(wc -l tmp.no-maff | awk '{print $1}')

    echo -e $tf "\t" $maff "\t" $tmaff "\t" $nomaff "\t" $tnomaff >> tmp.tf
    rm bed
done


python $scriptDir/fisher-test-tf-motif-fcc.py tmp.tf > Table-Input-Data/Supplementary-Table-13g.MAFF-MAFK-TF-enrichment.txt
cp Table-Input-Data/Supplementary-Table-13g.MAFF-MAFK-TF-enrichment.txt Figure-Input-Data/Supplementary-Figure-20b.MAFF-MAFK-TF-enrichment.txt

