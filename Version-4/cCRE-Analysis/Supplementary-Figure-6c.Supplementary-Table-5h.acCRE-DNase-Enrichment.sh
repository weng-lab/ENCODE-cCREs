#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

#wget
acre=hdma_global_acCREs.bed
current=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
V2=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Simple.bed
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

bedtools intersect -v -a $acre -b $V2 | bedtools intersect -u -b stdin -a $current > tmp.V4
group=tmp.V4

python $scriptDir/Toolkit/group-biosamples.py $list > tmp.stage
python $scriptDir/Toolkit/assign-organ-tissue.py $list GRCh38 > tmp.annotated
paste tmp.annotated tmp.stage | awk -F "\t" '{print $1 "\t" $2 "\t" $3 "\t" $6 "\t" $9}' > tmp.metadata


rm -f tmp.results
for j in `seq 1 1 1325`
do
    echo $j
    d=$(awk '{if (NR == '$j') print $1"-"$2}' $list)
    bio=$(awk '{if (NR == '$j') print $3}' $list)
    x1=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $group ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
	awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}') 
    x2=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $current ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
	awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}') 
    echo -e $d "\t" $bio "\t" $x1 "\t" $x2 >> tmp.results
done

awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' tmp.results > tmp.reformat
paste tmp.reformat tmp.metadata > Table-Input-Data/Supplementary-Table-5h.New-acCRE-DNase-Enrichment.txt

grep "adult tissue" Table-Input-Data/Supplementary-Table-5h.New-acCRE-DNase-Enrichment.txt > tmp.tissues
grep "embryonic tissue" Table-Input-Data/Supplementary-Table-5h.New-acCRE-DNase-Enrichment.txt >> tmp.tissues

cat tmp.tissues | sed "s/'//g" > Figure-Input-Data/Supplementary-Figure-6d.acREs-DNase-Enrichment.txt
rm tmp*
