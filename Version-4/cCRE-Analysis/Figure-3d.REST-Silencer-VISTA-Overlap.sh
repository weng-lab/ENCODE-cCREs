#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Figure 3e

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
vista=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/VISTA/VISTA-hg38.04-22-2023.bed

cd $workingDir

rm -f tmp.results

class=REST-Enhancers

cat $class.bed | \
    bedtools intersect -F 1 -wo -a $vista -b stdin | awk -F "\t" '{print $11 "\t" $5}' | sort -u | \
    awk 'BEGIN{sum=0}{if ($2 == "positive") sum += 1} \
    END{print "'$class'\tREST+" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR}' >> tmp.results

cat $class.bed| \
    awk 'FNR==NR {x[$4];next} !($4 in x)' - ../../hg38-cCREs-Unfiltered.bed | \
    awk '{if ($NF ~ /ELS/ ) print $0}' - | \
    bedtools intersect -F 1 -wo -a $vista -b stdin | awk -F "\t" '{print $11 "\t" $5}' | sort -u | \
    awk 'BEGIN{sum=0}{if ($2 == "positive") sum += 1} \
    END{print "'$class'\tREST-" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR}' >> tmp.results

class=REST-Silencers

cat $class.bed | \
    bedtools intersect -F 1 -wo -a $vista -b stdin | awk -F "\t" '{print $11 "\t" $5}' | sort -u | \
    awk 'BEGIN{sum=0}{if ($2 == "positive") sum += 1} \
    END{print "'$class'\tREST+" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR}' >> tmp.results

cat $class.bed| \
    awk 'FNR==NR {x[$4];next} !($4 in x)' - ../../hg38-cCREs-Unfiltered.bed | \
    awk '{if ($NF !~ /ELS/ && $NF !~ /PLS/ ) print $0}' - | \
    bedtools intersect -F 1 -wo -a $vista -b stdin | awk -F "\t" '{print $11 "\t" $5}' | sort -u | \
    awk 'BEGIN{sum=0}{if ($2 == "positive") sum += 1} \
    END{print "'$class'\tREST-" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR}' >> tmp.results



mv tmp.results Figure-Input-Data/Figure-3d.REST-Silencer-VISTA.txt
