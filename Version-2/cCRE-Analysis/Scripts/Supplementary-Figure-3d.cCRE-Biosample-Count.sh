#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-3d.cCRE-Biosample-Count.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts/
accessionMatrix=$dataDir/Cell-Type-Specific/Master-Cell-List.txt
ccres=$dataDir/hg38-ccREs-Simple.bed

awk '{if ($NF == "Group1") print $0}' $accessionMatrix > tmp.Group1
awk -F "," '{print $1}' $ccres > tmp.ccres

rm -f tmp.results
q=$(wc -l tmp.Group1 | awk '{print $1}')
for j in `seq 1 1 $q`
do
    echo $j
    bed=$(awk '{if (NR == "'$j'") print $2"_"$4"_"$6"_"$8".7group.bed"}' tmp.Group1)
    awk '{print $4 "\t" $10}' $dataDir/Cell-Type-Specific/Seven-Group/$bed | awk -F "," '{print $1}' > tmp.cts
    awk 'FNR==NR {x[$5$6];next} ($1$2 in x)' tmp.ccres tmp.cts >> tmp.results
done

awk 'FNR==NR {x[$1];next} ($5 in x)' tmp.results $ccres > tmp.agnostic
python $scriptDir/count-biosamples.py tmp.agnostic tmp.results > Group1-$q-Biosample-Counts.txt

