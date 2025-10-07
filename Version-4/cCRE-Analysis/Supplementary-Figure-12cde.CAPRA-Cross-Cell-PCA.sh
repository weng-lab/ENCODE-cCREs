#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 12cde

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization/Cross-Cell
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

mkdir -p $workingDir
cd $workingDir

#wget https://users.moore-lab.org/ENCODE-cCREs/Suppl
#tar -xvzf Supplementary-Data-5.CAPRA-Quantifications-Solo.tar.gz

starrs=(ENCSR661FOW ENCSR858MPS ENCSR064KUD ENCSR135NXN ENCSR547SBZ ENCSR895FDL ENCSR983SZZ)
for starr in ${starrs[@]}
do
    echo $starr
    awk '{if ($2 >= 10) print $1}' ../CAPRA-Output/$starr-Matrix.Solo-Filtered.V7.txt | \
        awk 'FNR==NR {x[$1];next} ($1 in x)' - ../CAPRA-Output/$starr-DESeq2.Solo-Filtered.V7.txt >> tmp.profile
done

python $scriptDir/Toolkit/count.py tmp.profile 0 > tmp.counts

awk '{if ($2 == 7) print $0}' tmp.counts > tmp.candidates

sort -k1,1 tmp.candidates | awk 'BEGIN{print "ccre"}{print $1}' > tmp.matrix
for starr in ${starrs[@]}
do
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.candidates ../CAPRA-Output/$starr-DESeq2.Solo-Filtered.V7.txt | \
        sort -k1,1 | awk 'BEGIN{print "'$starr'"}{print $3}' | paste tmp.matrix - > tmp.tmp
    mv tmp.tmp tmp.matrix
done

mv tmp.matrix CAPRA-Cross-Cell-Matrix.txt

python $scriptDir/Toolkit/starr-pca.py CAPRA-Cross-Cell-Matrix.txt > tmp.pca

head -n 1 CAPRA-Cross-Cell-Matrix.txt > tmp.pc1
head -n 1 CAPRA-Cross-Cell-Matrix.txt > tmp.pc2

sort -k2,2rg tmp.load | head -n 500 | awk 'FNR==NR {x[$1];next} ($1 in x)' - CAPRA-Cross-Cell-Matrix.txt >> tmp.pc1
sort -k3,3rg tmp.load | head -n 500 | awk 'FNR==NR {x[$1];next} ($1 in x)' - CAPRA-Cross-Cell-Matrix.txt >> tmp.pc2

mv tmp.pca ../Figure-Input-Data/Supplementary-Figure-12c.CAPRA-Cross-Cell-PCA.txt
mv tmp.pc1 ../Figure-Input-Data/Supplementary-Figure-12d.CAPRA-Cross-Cell-PC1.txt
mv tmp.pc2 ../Figure-Input-Data/Supplementary-Figure-12e.CAPRA-Cross-Cell-PC2.txt

rm tmp.*

