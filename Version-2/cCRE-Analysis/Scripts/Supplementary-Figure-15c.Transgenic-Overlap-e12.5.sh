#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-15c.Transgenic-Overlap-e12.5.sh

rm -f Transgenic-Summary-12.5.txt

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-mm10/
ccre=$dataDir/mm10-ccREs-Simple.bed
dataMatrix=$dataDir/Cell-Type-Specific/Master-Cell-List.txt
proxTSS=~/Lab/Reference/Mouse/GencodeM4/TSS.Filtered.4K.bed
testedRegions=$dataDir/Manuscript-Analysis/VISTA-Ren/Supplementary-Table-22g.txt
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts

tissues=(Forebrain Heart Limb)
for tissue in ${tissues[@]}
do
    echo "Processing" $tissue "..."
    lowerTissue=$(echo $tissue | awk '{print tolower($0)}')
    hisID=$(grep $lowerTissue $dataMatrix | grep 12.5 | awk '{print $5"-"$6}')
    h3k27acSigs=$dataDir/signal-output/$hisID.txt

    awk -F "\t" '{if ($1 == "'$tissue'") print $3 "\t" $2}' $testedRegions | \
        awk '{gsub(/-/,"\t");print}' | awk '{gsub(/:/,"\t");print}' > tmp.regions
    awk -F "\t" '{if ($1 == "'$tissue'") print $2 "\t" $3 "\t" $4}' $testedRegions > tmp.key

    bedtools intersect -v -a $ccre -b $proxTSS > tmp.distal
    bedtools intersect -F 1 -wo -a tmp.regions -b $ccre > tmp.overlap

    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.distal $h3k27acSigs | sort -k2,2rg | \
        awk 'BEGIN {rank=0; before=0; running=1}{if ($2 != before) \
        rank = running; print $1 "\t" $2 "\t" $3 "\t" rank; before=$2; \
        running += 1}' | sort -k1,1 > tmp.hDistal
    
    python select-one-ccres.py tmp.hDistal tmp.hDistal tmp.hDistal tmp.overlap tmp.key | \
        sort -k1,1 | awk '{if ($5 < 1000) group="top"; else group="bottom"; \
        print "'$tissue'" "\t" $1 "\t" $2 "\t" $5 "\t" group}' >> Transgenic-Summary-12.5.txt
done
