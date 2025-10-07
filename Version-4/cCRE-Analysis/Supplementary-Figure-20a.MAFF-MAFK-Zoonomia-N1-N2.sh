#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 20a

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/4_MAFF-MAFK
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

#wget
ccres=../1_Updated-Registry/Conservation/GRCh38-cCREs-V4-Zoonomia-N1-N2.bed

cd $workingDir

awk 'FNR==NR {x[$4];next} ($4 in x)' MAFF-MAFK.Common-Low-DNase.bed $ccres > MAFF-MAFK.Common-Low-DNase
cat MAFF-MAFK.Common-Low-DNase | awk 'BEGIN{G1=0; G2=0; G3=0}{if ($7 >= 120 && $8 <=25) G1 +=1 ; \
        if ($7 >= 20 && $7 <= 50 && $8 <= 120) G2 +=1 ; \
        if ($7 <= 5 && $8 >= 235) G4 +=1 ; \
        if ($7 <= 50 && $8 >= 180) G3 +=1}END{print "MAFF-MAFK.Common-Low-DNase" "\t" G1/NR "\t" G2/NR "\t" G3/NR "\t" G4/NR}'
Rscript $scriptDir/Toolkit/plot-zoonomia-triangle.R MAFF-MAFK.Common-Low-DNase

mv Zoonomia-Triangle-*png Raw-Figures/
rm MAFF-MAFK.Common-Low-DNase
