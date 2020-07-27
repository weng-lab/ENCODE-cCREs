#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-15d.Transgenic-Overlap-Pilot.sh

rm -f Transgenic-Summary-Pilot.txt

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-mm10/
ccre=$dataDir/mm10-ccREs-Simple.bed
dataMatrix=$dataDir/Cell-Type-Specific/Master-Cell-List.txt
proxTSS=~/Lab/Reference/Mouse/GencodeM4/TSS.Filtered.4K.bed
testedRegions=$dataDir/Manuscript-Analysis/VISTA-Ren/Gerstein/Supplementary-Table-22l.txt
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts

tissues=(Forebrain Heart)
for tissue in ${tissues[@]}
do
    echo "Processing" $tissue "..."
    lowerTissue=$(echo $tissue | awk '{print tolower($0)}')
    hisID=$(grep "C57BL/6_"$lowerTissue $dataMatrix | grep 11.5 | awk '{print $5"-"$6}')
    dnaseID=$(grep "C57BL/6_"$lowerTissue $dataMatrix | grep 11.5 | awk '{print $1"-"$2}')
    dnaseSigs=$dataDir/signal-output/$dnaseID.txt
    h3k27acSigs=$dataDir/signal-output/$hisID.txt

    awk -F "\t" '{if ($1 == "'$tissue'") print $3 "\t" $2}' $testedRegions | \
        awk '{gsub(/-/,"\t");print}' | awk '{gsub(/:/,"\t");print}' > tmp.regions
    awk -F "\t" '{if ($1 == "'$tissue'") print $2 "\t" $3 "\t" $4}' $testedRegions > tmp.key

    bedtools intersect -v -a $ccre -b $proxTSS > tmp.distal
    bedtools intersect -F 1 -wo -a tmp.regions -b $ccre > tmp.overlap

    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.distal $dnaseSigs | sort -k2,2rg | \
        awk 'BEGIN {rank=0; before=0; running=1}{if ($2 != before) \
        rank = running; print $1 "\t" $2 "\t" $3 "\t" rank; before=$2; \
        running += 1}' | sort -k1,1 > tmp.dDistal

    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.distal $h3k27acSigs | sort -k2,2rg | \
        awk 'BEGIN {rank=0; before=0; running=1}{if ($2 != before) \
        rank = running; print $1 "\t" $2 "\t" $3 "\t" rank; before=$2; \
        running += 1}' | sort -k1,1 > tmp.hDistal

    paste tmp.dDistal tmp.hDistal | awk '{print $1 "\t" $4 "\t" $8 "\t" ($4+$8)/2}' | \
        sort -k4,4g | awk 'BEGIN {rank=0; before=0; running=1}{if ($4 != before) \
        rank = running; print $1 "\t" $2 "\t" $3 "\t" rank; before=$4; \
        running += 1}' > tmp.aveRank
    
    if [ $tissue == "Heart" ]
    then
        python $scriptDir/select-one-ccres.py tmp.dDistal tmp.hDistal tmp.aveRank tmp.overlap tmp.key | \
            sort -k1,1 | awk '{if ($NF < 1000) group="top"; else if ($NF < 15000) group="middle"; else group="bottom"; \
            print "'$tissue'" "\t" $1 "\t" $2 "\t" $NF "\t" group}' >> Transgenic-Summary-Pilot.txt
    elif [ $tissue == "Forebrain" ]
    then
        python $scriptDir/select-one-ccres.py tmp.dDistal tmp.hDistal tmp.aveRank tmp.overlap tmp.key | \
            sort -k1,1 | awk '{if ($NF < 3000) group="top"; else if ($NF < 15000) group="middle"; else group="bottom"; \
            print "'$tissue'" "\t" $1 "\t" $2 "\t" $NF "\t" group}' >> Transgenic-Summary-Pilot.txt

    fi
done
