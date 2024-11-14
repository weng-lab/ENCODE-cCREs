#!/bin/bash

scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/TF-Enrichment

tfList=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-TF/hg38-TF-List.Filtered-K562.txt

capraQuant=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Fragment-Analysis/ENCSR661FOW/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
silencer1=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/STARR-Silencers.Stringent.bed
silencer2=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/STARR-Silencers.Robust.bed
control1=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/ENCSR661FOW-Active-1.bed
control2=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/ENCSR661FOW-Neutral.bed
ccres=../../../hg38-cCREs-Unfiltered.bed

cd $workingDir

#make controls

awk '{if ($(NF-1) < 0.01) print $0}' $capraQuant | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - $ccres > $control1


low=-0.04753247 #45th percentile
high=0.01608335 #55th percentile
awk '{if ($3 < '$high' && $3 > '$low') print $0}' $capraQuant | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - $ccres > $control2

totalS1=$(wc -l $silencer1 | awk '{print $1}')
totalS2=$(wc -l $silencer2 | awk '{print $1}')
totalC1=$(wc -l $control1 | awk '{print $1}')
totalC2=$(wc -l $control2 | awk '{print $1}')

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
    awk '{print $1 "\t" $2+$10-1 "\t" $2+$10}' bed > tmp.tf-bed
    S1=$(bedtools intersect -u -a $silencer1 -b tmp.tf-bed | wc -l | awk '{print $1}')
    S2=$(bedtools intersect -u -a $silencer2 -b tmp.tf-bed | wc -l | awk '{print $1}')
    C1=$(bedtools intersect -u -a $control1 -b tmp.tf-bed | wc -l | awk '{print $1}')
    C2=$(bedtools intersect -u -a $control2 -b tmp.tf-bed | wc -l | awk '{print $1}')

    echo -e $exp "\t" $peak "\t" $tf "\t" $S1 "\t" $totalS1 "\t" $S2 "\t" $totalS2 "\t" $C1 "\t" $totalC1 "\t" $C2 "\t" $totalC2 >> tmp.results
done

python $scriptDir/fisher-test-tf-silencer-enrichment.py tmp.results > ../Table-Input-Data/Supplementary-Table-8c.Silencer-TF-Enrichment.txt
rm tmp.*
