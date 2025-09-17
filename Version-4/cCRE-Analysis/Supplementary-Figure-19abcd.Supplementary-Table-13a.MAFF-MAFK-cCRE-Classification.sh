#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 19abcd

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/4_MAFF-MAFK
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
cd $workingDir

cells=(K562 HepG2)
for cell in ${cells[@]}
do
    echo $cell
    dnase=$(grep $cell ../../DNase-List.txt | grep -v "treated" | grep -v "phase" | awk '{print $2}')
    ccres=../../hg38-cCREs-Unfiltered.bed
    cts=../../Cell-Type-Specific/Individual-Files/$dnase*bed


    grep MAFF ../../hg38-TF/All-$cell-Peak-Summits.bed > tmp.maff
    grep MAFK ../../hg38-TF/All-$cell-Peak-Summits.bed > tmp.mafk


    bedtools intersect -u -a $ccres -b tmp.maff | bedtools intersect -u -a stdin -b tmp.mafk > $cell-MAFF-MAFK.Agnostic.bed
    awk 'FNR==NR {x[$5];next} ($4 in x)' $cell-MAFF-MAFK.Agnostic.bed $cts > $cell-MAFF-MAFK.$cell.bed

    python $scriptDir/Toolkit/count.py $cell-MAFF-MAFK.$cell.bed 9 | sort -k1,1 | awk '{print "All-'$cell'" "\t" $0}' >> tmp.out

    grep Low-DNase $cell-MAFF-MAFK.$cell.bed | awk 'FNR==NR {x[$4];next} ($5 in x)' - $cell-MAFF-MAFK.Agnostic.bed > tmp.low
    python $scriptDir/Toolkit/count.py tmp.low -1 | sort -k1,1 | awk '{print "Low-'$cell'" "\t" $0}' >> tmp.out

done

grep Low-DNase K562-MAFF-MAFK.K562.bed | awk 'FNR==NR {x[$4];next} ($4 in x)' - HepG2-MAFF-MAFK.HepG2.bed | grep Low-DNase | awk 'FNR==NR {x[$4];next} ($5 in x)' - $ccres > MAFF-MAFK.Common-Low-DNase.bed

mv tmp.out Figure-Input-Data/Supplementary-Figure-19abcd.MAFF-MAFK-cCRE-Classification.txt
rm tmp.*
