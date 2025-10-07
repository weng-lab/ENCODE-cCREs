#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 15c

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
vista=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/VISTA/VISTA-hg38.04-22-2023.bed

cd $workingDir

rm -f tmp.results
classes=(PLS pELS dELS CA-CTCF CA-H3K4me3 CA-TF TF)
for class in ${classes[@]}
do

awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | \
    bedtools intersect -F 1 -wo -a $vista -b stdin | awk -F "\t" '{print $11 "\t" $5}' | sort -u | \
    awk 'BEGIN{sum=0}{if ($2 == "positive") sum += 1} \
    END{if (NR > 0) print "'$class'\tREST+" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR;
    else print "'$class'\tREST+" "\t" 0 "\t" 0 "\t" 0 "\t" 0}' >> tmp.results

awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | \
    awk 'FNR==NR {x[$4];next} !($4 in x)' - ../../hg38-cCREs-Unfiltered.bed | \
    awk '{if ($NF == "'$class'") print $0}' - | \
    bedtools intersect -F 1 -wo -a $vista -b stdin | awk -F "\t" '{print $11 "\t" $5}' | sort -u | \
    awk 'BEGIN{sum=0}{if ($2 == "positive") sum += 1} \
    END{print "'$class'\tREST-" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR}' >> tmp.results


done

mv tmp.results Figure-Input-Data/Supplementary-Figure-15c.REST-cCRE-VISTA-Overlap.txt
