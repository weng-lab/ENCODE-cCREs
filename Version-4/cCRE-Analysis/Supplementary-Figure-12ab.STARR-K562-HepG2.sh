#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 12cde

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

groups=(PLS dELS)
for group in ${groups[@]}
do
    echo $group
    grep $group $ccres > tmp.ccres
    star=ENCSR858MPS
    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres CAPRA-Output/$star-DESeq2.Solo-Filtered.V7.txt | \
        awk '{print $1 "\t" $3}' > tmp.col
    star=ENCSR135NXN
    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres CAPRA-Output/$star-DESeq2.Solo-Filtered.V7.txt | \
        awk '{print $3}' | paste tmp.col - > tmp.$group
done

mv tmp.PLS Figure-Input-Data/Supplementary-Figure-12a.STARR-K562-HepG2-PLS.txt
mv tmp.dELS Figure-Input-Data/Supplementary-Figure-12b.STARR-K562-HepG2-dELS.txt
rm tmp*
