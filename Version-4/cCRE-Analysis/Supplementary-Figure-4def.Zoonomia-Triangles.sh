#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 4def

source ~/.bashrc
conda activate rlab

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Conservation

#wget
ccres=$workingDir/GRCh38-cCREs-V4-Zoonomia-N1-N2.bed

cd $workingDir

classes=$(awk '{print $6}' $ccres | sort -u )
for class in ${classes[@]}
do
    awk '{if ($6 == "'$class'") print $0}' $ccres > $class
    cat $class | awk 'BEGIN{G1=0; G2=0; G3=0; G4=0}{if ($7 >= 120 && $8 <=25) G1 +=1 ; \
    if ($7 >= 20 && $7 <= 50 && $8 <= 120) G2 +=1 ; \
    if ($7 <= 5 && $8 >= 235) G4 +=1 ; \
    if ($7 <= 50 && $8 >= 180) G3 +=1}END{print "'$class'" "\t" G1/NR "\t" G2/NR "\t" G3/NR "\t" G4/NR}'
    Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit/plot-zoonomia-triangle.R $class
    mv Zoonomia-Triangle-*png ../Raw-Figures/
    rm $class
done

cp $ccres All-cCREs
Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit/plot-zoonomia-triangle.R All-cCREs
mv Zoonomia-Triangle-*png ../Raw-Figures/
cat All-cCREs | awk 'BEGIN{G1=0; G2=0; G3=0; G4=0}{if ($7 >= 120 && $8 <=25) G1 +=1 ; \
    if ($7 >= 20 && $7 <= 50 && $8 <= 120) G2 +=1 ; \
    if ($7 <= 5 && $8 >= 235) G4 +=1 ; \
    if ($7 <= 50 && $8 >= 180) G3 +=1}END{print "All" "\t" G1/NR "\t" G2/NR "\t" G3/NR "\t" G4/NR}'
rm All-cCREs

#wget
ccres=$workingDir/Background.N1-N2.bed

cp $ccres Background
cat Background | awk 'BEGIN{G1=0; G2=0; G3=0; G4=0}{if ($7 >= 120 && $8 <=25) G1 +=1 ; \
    if ($7 >= 20 && $7 <= 50 && $8 <= 120) G2 +=1 ; \
    if ($7 <= 5 && $8 >= 235) G4 +=1 ; \
    if ($7 <= 50 && $8 >= 180) G3 +=1}END{print "Background" "\t" G1/NR "\t" G2/NR "\t" G3/NR "\t" G4/NR}'
Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit/plot-zoonomia-triangle.R Background
mv Zoonomia-Triangle-*png ../Raw-Figures/
rm -f Background tmp.*

