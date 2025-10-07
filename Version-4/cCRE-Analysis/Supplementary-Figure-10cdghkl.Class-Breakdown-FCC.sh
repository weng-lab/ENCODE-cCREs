#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 10cdghkl

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization/cCRE-Enrichment
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit

ccreK562=K562-cCREs.bed

cd $workingDir

###MPRA
#wget https://www.encodeproject.org/files/ENCFF677CJZ/@@download/ENCFF677CJZ.bed.gz
#gunzip ENCFF677CJZ.bed.gz
mpra=ENCFF677CJZ.bed
awk '{if ($7 > 1) print $0}' $mpra > tmp.positive
regions=tmp.positive

bedtools intersect -u -a $ccreK562 -b tmp.positive > tmp.yes
bedtools intersect -u -a $ccreK562 -b $mpra > tmp.1

python $scriptDir/count.py tmp.yes 9 | sort -k1,1 | awk '{print "MPRA" "\t" "active" "\t" $0}' > tmp.results
python $scriptDir/count.py tmp.1 9 | sort -k1,1 | awk '{print "MPRA" "\t" "tested" "\t" $0}' >> tmp.results

###STARR-seq
regions=ENCFF454ZKK.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig ENCFF454ZKK.bed out.tab
min=$(sort -k5,5g out.tab | head -n 1 | awk '{print $5}')

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $ccreK562 > tmp.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig tmp.bed tmp.out
awk '{if ($NF > '$min') print $0}' tmp.out | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - $ccreK562 | \
    bedtools intersect -f 0.5 -c -a stdin -b $regions > tmp.1

awk '{if ($NF > 0) print $0}' tmp.1 > tmp.yes

python $scriptDir/count.py tmp.yes 9 | sort -k1,1 | awk '{print "STARR" "\t" "active" "\t" $0}' >> tmp.results
python $scriptDir/count.py tmp.1 9 | sort -k1,1 | awk '{print "STARR" "\t" "tested" "\t" $0}' >> tmp.results

###CRISPR
list=CRISPR-Sabeti.gRNA.txt
for i in `seq 1 1 9`
do
    exp=$(awk -F "\t" '{if (NR == '$i') print $1}' $list)
#    wget https://www.encodeproject.org/files/$exp/@@download/$exp.bed.gz
#    gunzip $exp.bed.gz
    cat $exp.bed | awk '{if ($1 ~ /chr/) print $0}' >> tmp.guide
done

regions=Reilly-Tewhey.41588_2021_900_MOESM3_ESM.Table-3.bed

bedtools intersect -u -a $ccreK562 -b tmp.guide | \
    bedtools intersect -u -a stdin -b $regions > tmp.yes

bedtools intersect -u -a $ccreK562 -b tmp.guide > tmp.1

python $scriptDir/count.py tmp.yes 9 | sort -k1,1 | awk '{print "CRISPR" "\t" "active" "\t" $0}' >> tmp.results
python $scriptDir/count.py tmp.1 9 | sort -k1,1 | awk '{print "CRISPR" "\t" "tested" "\t" $0}' >> tmp.results

mv tmp.results ../Figure-Input-Data/Supplementary-Figure-10cdghkl.FCC-cCRE-Class.txt
rm tmp.*
