#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Figure 3e

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
vista=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/VISTA/VISTA-hg38.04-22-2023.bed
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

cd $workingDir

rm -f tmp.results

class=REST-Enhancers

cat $class.bed | 
    bedtools intersect -F 1 -u -a $vista -b stdin | grep "positive" > tmp.1

cat $class.bed| \
    awk 'FNR==NR {x[$4];next} !($4 in x)' - ../../hg38-cCREs-Unfiltered.bed | \
    awk '{if ($NF ~ /ELS/ ) print $0}' - | \
    bedtools intersect -F 1 -u -a $vista -b stdin | grep "positive" > tmp.2

python $scriptDir/Toolkit/count-vista-tissues.py tmp.1 tmp.2 > tmp.results

awk -F "\t" '{print $3 "\t" $1}' tmp.results | sort -k1,1rg | head -n 6 | \
    awk -F "\t" 'FNR==NR {x[$2];next} ($1 in x)' - tmp.results \
    > Figure-Input-Data/Figure-3e.REST-Silencer-VISTA-Enrichment.txt

mv tmp.results Table-Input-Data/Supplementary-Table-7e.REST-Silencer-VISTA-Enrichment.txt

