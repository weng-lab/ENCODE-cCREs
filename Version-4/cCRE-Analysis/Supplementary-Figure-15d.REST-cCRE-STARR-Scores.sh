#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 15d

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
quants=../2_Functional-Characterization/CAPRA-Output/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt

cd $workingDir

rm -f tmp.results
classes=(PLS pELS dELS CA-CTCF CA-H3K4me3 CA-TF TF)
for class in ${classes[@]}
do

awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | awk 'FNR==NR {x[$4];next} ($1 in x)' - $quants | \
    awk '{print $1 "\t" $3 "\t" "'$class'" "\t" "REST+"}' >> tmp.results

awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | \
    awk 'FNR==NR {x[$4];next} !($4 in x)' - ../../hg38-cCREs-Unfiltered.bed | \
    awk '{if ($NF == "'$class'") print $0}' - | awk 'FNR==NR {x[$4];next} ($1 in x)' - $quants | \
    awk '{print $1 "\t" $3 "\t" "'$class'" "\t" "REST-"}' >> tmp.results

done

mv tmp.results Figure-Input-Data/Supplementary-Figure-15d.REST-cCRE-STARR-Scores.txt
