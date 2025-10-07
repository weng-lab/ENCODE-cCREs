#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 18fghi

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers

#wget
ccres=../1_Updated-Registry/Conservation/GRCh38-cCREs-V4-Zoonomia-N1-N2.bed

cd $workingDir

classes=(Cai-Fullwood-2021 Huan-Ovcharenko-2019 Jayavelu-Hawkins-2020 Pang-Snyder-2020)
for class in ${classes[@]}
do
    awk 'FNR==NR {x[$4];next} ($4 in x)' Published-Silencers/$class/Positive-cCREs.bed $ccres > $class
    cat $class | awk 'BEGIN{G1=0; G2=0; G3=0}{if ($7 >= 120 && $8 <=25) G1 +=1 ; \
        if ($7 >= 20 && $7 <= 50 && $8 <= 120) G2 +=1 ; \
        if ($7 <= 5 && $8 >= 235) G4 +=1 ; \
        if ($7 <= 50 && $8 >= 180) G3 +=1}END{print "'$class'" "\t" G1/NR "\t" G2/NR "\t" G3/NR "\t" G4/NR}'
    Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit/plot-zoonomia-triangle.R $class
    mv Zoonomia-Triangle-*png Raw-Figures/
    rm $class
done

