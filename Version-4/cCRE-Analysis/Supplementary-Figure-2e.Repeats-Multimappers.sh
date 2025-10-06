#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 2e

source ~/.bashrc
conda activate notebook

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Multimappers
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit
cd $workingDir

ccres=../../../hg38-cCREs-Unfiltered.bed
ccresMM=../../../hg38-MultiMap-cCREs.bed
other=../Background.No-cCREs.bed
bed=~/Lab/Reference/Human/hg38/hg38-RepeatMasker.bed

T1=$(wc -l $ccres | awk '{print $1}')
T2=$(wc -l $ccresMM | awk '{print $1}')
T3=$(wc -l $other | awk '{print $1}')


repeats=$(awk '{print $5}' $bed | sort -u)

C1=$(bedtools intersect -u -a $ccres -b $bed | wc -l | awk '{print $1}')
C2=$(bedtools intersect -u -a $ccresMM -b $bed | wc -l | awk '{print $1}')
C3=$(bedtools intersect -u -a $other -b $bed | wc -l | awk '{print $1}')
echo -e "All" "\t" $C2 "\t" $T2 "\t" $C1 "\t" $T1 "\t" $C3 "\t" $T3 > tmp.out


for repeat in ${repeats[@]}
do
    echo $repeat
    awk '{if ($5 == "'$repeat'") print $0}' $bed > tmp.bed
    C1=$(bedtools intersect -u -a $ccres -b tmp.bed | wc -l | awk '{print $1}')
    C2=$(bedtools intersect -u -a $ccresMM -b tmp.bed | wc -l | awk '{print $1}')
    C3=$(bedtools intersect -u -a $other -b tmp.bed | wc -l | awk '{print $1}')
    echo -e $repeat "\t" $C2 "\t" $T2 "\t" $C1 "\t" $T1 "\t" $C3 "\t" $T3 >> tmp.out
done

python $scriptDir/fisher-test-repeats-multimap.py tmp.out > tmp.results

rm -f tmp.out

repeats=$(awk '{if ($5 == "SINE") print $6}' $bed | sort -u)

for repeat in ${repeats[@]}
do
    echo $repeat
    awk '{if ($5 == "SINE" && $6 == "'$repeat'") print $0}' $bed > tmp.bed
    C1=$(bedtools intersect -u -a $ccres -b tmp.bed | wc -l | awk '{print $1}')
    C2=$(bedtools intersect -u -a $ccresMM -b tmp.bed | wc -l | awk '{print $1}')
    C3=$(bedtools intersect -u -a $other -b tmp.bed | wc -l | awk '{print $1}')
    echo -e "SINE-"$repeat "\t" $C2 "\t" $T2 "\t" $C1 "\t" $T1 "\t" $C3 "\t" $T3  >> tmp.out
done

python $scriptDir/fisher-test-repeats-multimap.py tmp.out >> tmp.results

mv tmp.results ../Table-Input-Data/Supplementary-Table-3e.Multimapper-Repeat-Overlap.txt

awk '{print $1 "\t"  $2/$3 "\t" $4/$5 "\t" $6/$7}' ../Table-Input-Data/Supplementary-Table-3e.Multimapper-Repeat-Overlap.txt | \
    awk 'BEGIN{print "repeat" "\t" "multimap" "\t" "unique" "\t" "background"} \
    {if ($2 > 0.01 || $3 > 0.01 || $4 > 0.01) print $0}' > \
    ../Figure-Input-Data/Supplementary-Figure-2e.Multimapper-Repeat-Overlap.txt

rm tmp.*




