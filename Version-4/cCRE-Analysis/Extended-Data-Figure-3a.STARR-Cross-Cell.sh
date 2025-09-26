#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Extended Data Figure 3a

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs #available to download
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

grep dELS $ccres > tmp.ccres
stars=(ENCSR858MPS ENCSR135NXN)
star=ENCSR858MPS
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres CAPRA-Output/$star-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $1 "\t" $3}' > tmp.col
star=ENCSR135NXN
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres CAPRA-Output/$star-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $3}' | paste tmp.col - > tmp.matrix

awk '{if ($2 > 0 && $2 > $3+1) print $0}' tmp.matrix > tmp.K562
awk '{if ($3 > 0 && $3 > $2+1) print $0}' tmp.matrix > tmp.HepG2

group=tmp.K562
tf=GATA1
awk 'FNR==NR {x[$2];next} ($1 in x)' $tfDir/$tf"_HUMAN.H11MO"*txt $group > tmp.ccres
rm -f tmp.data
stars=(ENCSR858MPS ENCSR135NXN ENCSR064KUD ENCSR547SBZ)
for star in ${stars[@]}
do
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.ccres CAPRA-Output/$star-DESeq2.Solo-Filtered.V7.txt | \
        awk '{print $1 "\t" $3 "\t" "'$star'" "\t" "'$tf'"}' >> tmp.data
done

group=tmp.HepG2
tfs=(HNF4A P53 GFI1B)
for tf in ${tfs[@]}
do
    awk 'FNR==NR {x[$2];next} ($1 in x)' $tfDir/$tf"_HUMAN.H11MO"*txt $group > tmp.ccres
    stars=(ENCSR858MPS ENCSR135NXN ENCSR064KUD ENCSR547SBZ) 
    for star in ${stars[@]}
    do
	echo $star
        awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.ccres CAPRA-Output/$star-DESeq2.Solo-Filtered.V7.txt | \
	    awk '{print $1 "\t" $3 "\t" "'$star'" "\t" "'$tf'"}' >> tmp.data
    done
done
mv tmp.data Figure-Input-Data/Extended-Data-Figure-3a.cCRE-STARR-Activity.txt
rm tmp*
