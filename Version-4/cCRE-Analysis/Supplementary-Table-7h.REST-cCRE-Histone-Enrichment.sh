#!/bin/bash

scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/TF-Enrichment

capraQuant=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Fragment-Analysis/ENCSR661FOW/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
silencer1=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/REST-Enhancers.bed
silencer2=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/REST-Silencers.bed
control1=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/K562.bed
control2=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/K562-Inactive.bed
ccres=../../../hg38-cCREs-Unfiltered.bed
k562ccre=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/ENCFF414OGC_ENCFF806YEZ_ENCFF849TDM_ENCFF736UDR.bed

cd $workingDir

#make controls

grep -v Low-DNase $k562ccre > $control1
grep Low-DNase $k562ccre > $control2

totalS1=$(wc -l $silencer1 | awk '{print $1}')
totalS2=$(wc -l $silencer2 | awk '{print $1}')
totalC1=$(wc -l $control1 | awk '{print $1}')
totalC2=$(wc -l $control2 | awk '{print $1}')

python $scriptDir/pull-k562-histone-peaks.py > tmp.list
tfList=tmp.list

rm -f tmp.results
k=$(wc -l $tfList | awk '{print $1}')
for j in `seq 1 1 $k`
do
    echo $j
    exp=$(awk -F "\t" '{if (NR == '$j') print $1}' $tfList)
    peak=$(awk -F "\t" '{if (NR == '$j') print $2}' $tfList)
    tf=$(awk -F "\t" '{if (NR == '$j') print $4}' $tfList)
    

    if test -f "/data/projects/encode/data/$exp/$peak.bed.gz"
    then
        cp /data/projects/encode/data/$exp/$peak.bed.gz bed.gz
    else
        wget https://www.encodeproject.org/files/$peak/@@download/$peak.bed.gz
        mv $peak.bed.gz bed.gz
    fi
    gunzip bed.gz
    awk '{print $1 "\t" $2 "\t" $3}' bed > tmp.tf-bed
    S1=$(bedtools intersect -u -a $silencer1 -b tmp.tf-bed | wc -l | awk '{print $1}')
    S2=$(bedtools intersect -u -a $silencer2 -b tmp.tf-bed | wc -l | awk '{print $1}')
    C1=$(bedtools intersect -u -a $control1 -b tmp.tf-bed | wc -l | awk '{print $1}')
    C2=$(bedtools intersect -u -a $control2 -b tmp.tf-bed | wc -l | awk '{print $1}')
    rm bed
    echo -e $exp "\t" $peak "\t" $tf "\t" $S1 "\t" $totalS1 "\t" $S2 "\t" $totalS2 "\t" $C1 "\t" $totalC1 "\t" $C2 "\t" $totalC2 >> tmp.results
done

python $scriptDir/fisher-test-tf-silencer-enrichment.py tmp.results > ../Table-Input-Data/Supplementary-Table-7h.REST-Histone-Enrichment.txt
rm tmp.*
