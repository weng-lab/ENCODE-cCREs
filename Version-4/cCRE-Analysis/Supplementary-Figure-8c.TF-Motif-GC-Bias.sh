#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 8c

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

cd $workingDir

#wget
motifs=~/Lab/Reference/Motifs/HOCOMOCOv11_core_pwms_HUMAN_mono.txt
motifAnnotation=~/Lab/Reference/Motifs/HOCOMOCOv11_core_annotation_HUMAN_mono.tsv

#wget
promoter=K562.PLS.bed
enhancer=K562.dELS.bed
tfs=../../hg38-TF/hg38-TF-List.Filtered-K562.txt

python $scriptDir/Toolkit/calculate-tf-motif-gc.py $motifs > tmp

awk -F "\t" '{if (NR > 1) print $2}' $motifAnnotation | \
    paste - tmp > tmp.tf-gc
awk -F "\t" 'FNR==NR {x[$1];next} ($4 in x)' tmp.tf-gc $tfs > tmp.list

rm -f tmp.running
list=tmp.list
total=$(wc -l tmp.list | awk '{print $1}')
for i in `seq 1 1 $total`
do
    echo $i
    tf=$(awk -F "\t" '{if (NR == '$i') print $4}' $list)
    exp=$(awk -F "\t" '{if (NR == '$i') print $1}' $list)
    peak=$(awk -F "\t" '{if (NR == '$i') print $2}' $list)

    cp /data/projects/encode/data/$exp/$peak.bed.gz bed.gz
    gunzip bed.gz
    
    totP=$(wc -l bed | awk '{print $1}')
    totProm=$(bedtools intersect -u -a bed -b $promoter | wc -l | awk '{print $1}')

    bedtools intersect -u -a bed -b $enhancer | wc -l | \
      awk '{print "'$exp'" "\t" "'$tf'" "\t" "'$totP'" "\t" "'$totProm'" "\t" '$totProm'/'$totP' "\t" $1 "\t" $1/'$totP'}' >> tmp.running
    rm bed
done

python $scriptDir/Toolkit/gc-match-tf.py tmp.tf-gc tmp.running | awk '{if ($5 > 0.25 || $7 > 0.25) print $0}' > tmp.output

mv tmp.output Figure-Input-Data/Supplementary-Figure-8c.GC-TF-Motif-Preference.txt
rm tmp.*


