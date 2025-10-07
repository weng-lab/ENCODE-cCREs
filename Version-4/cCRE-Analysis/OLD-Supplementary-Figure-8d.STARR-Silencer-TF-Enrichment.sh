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

awk '{if (($4/$5) > ($8/$9) && ($4/$5) > ($10/$11) && ($6/$7) > ($8/$9) && \
    ($6/$7) > ($10/$11) && $13 < 0.05 && $15 < 0.05 && $17 < 0.05 && $19 < 0.05) print $0}' \
    ../Table-Input-Data/Supplementary-Table-7x.Silencer-TF-Enrichment.txt > tmp.sig

tfList=tmp.sig
k=$(wc -l $tfList | awk '{print $1}')
for j in `seq 1 1 $k`
do
    echo $j
    exp=$(awk '{if (NR == '$j') print $1}' $tfList)
    peak=$(awk '{if (NR == '$j') print $2}' $tfList)
    tf=$(awk '{if (NR == '$j') print $4}' $tfList)
    
    if test -f "/data/projects/encode/data/$exp/$peak.bed.gz"
    then
        cp /data/projects/encode/data/$exp/$peak.bed.gz bed.gz
    else
        wget https://www.encodeproject.org/files/$peak/@@download/$peak.bed.gz
        mv $peak.bed.gz bed.gz
    fi
    gunzip bed.gz
    bedtools intersect -u -a $silencer1 -b bed > tmp.$j
    rm bed
done

awk 'BEGIN{print "experiment"}{print $1"_"$2"_"$3}' tmp.sig > tmp.matrix
for j in `seq 1 1 $k`
do
    echo $j
    key=$(awk '{if (NR == '$j') print $1"_"$2"_"$3}' $tfList)
    total1=$(wc -l tmp.$j | awk '{print $1}')
    echo $key > tmp.col
    for i in `seq 1 1 $k`
    do
        echo -e "\t" $i
        total2=$(wc -l tmp.$i | awk '{print $1}')
        awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.$j tmp.$i | wc -l | \
            awk '{{if ('$total1' > '$total2') denom='$total2'; \
        else denom='$total1'}; print $1/denom}' >> tmp.col
    done
    paste tmp.matrix tmp.col > tmp.tmp
    mv tmp.tmp tmp.matrix
done

mv tmp.matrix ../Figure-Input-Data/Supplementary-Figure-9d.Silencer-TF-Overlap-Coefficients.txt
rm tmp.*
