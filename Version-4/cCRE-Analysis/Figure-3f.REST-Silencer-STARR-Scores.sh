#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Figure 3f

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
vista=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/VISTA/VISTA-hg38.04-22-2023.bed
quants=../2_Functional-Characterization/CAPRA-Output/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt

cd $workingDir

rm -f tmp.results

classes=(REST-Enhancers REST-Silencers)
for class in ${classes[@]}
do
    awk 'FNR==NR {x[$4];next} ($1 in x)' $class.bed $quants | awk '{print $1 "\t" $3 "\t" "'$class'"}' >> tmp.results
done

~/bin/randomLines -seed=6921 $quants 100000 tmp.quant
awk '{print $1 "\t" $3 "\t" "Background"}' tmp.quant >> tmp.results

mv tmp.results Figure-Input-Data/Figure-3f.REST-STARR-Scores.txt
rm tmp.*
