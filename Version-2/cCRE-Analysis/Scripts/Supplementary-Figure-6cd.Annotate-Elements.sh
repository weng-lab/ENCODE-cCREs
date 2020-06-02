
#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng


genome=$1
mode=$2
#ccres=$3

ccres=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/$genome-ccREs-Simple.bed

cd ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Manuscript-Analysis/Data-Contribution

echo "Splitting ccREs into groups..."
awk '{if ($2 > 1.64) print $0}' $genome-DNase-$mode-maxZ.txt > list

awk 'FNR==NR {x[$1];next} ($1 in x)' list $genome-H3K27ac-$mode-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' > tmp

awk 'FNR==NR {x[$1];next} ($1 in x)' list $genome-H3K4me3-$mode-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' >> tmp

awk 'FNR==NR {x[$1];next} ($1 in x)' list $genome-CTCF-$mode-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' >> tmp

awk 'FNR==NR {x[$1];next} ($4 in x)' tmp $ccres > tmp1

rm -f $mode-Summary.txt
datasets=("PLS" "pELS" "dELS" "DNase-H3K4me3" "CTCF-only")
for l in ${datasets[@]}
do
    grep $l tmp1 | wc -l | awk '{print "'$l'" "\t" $1}' >> $mode-Summary.txt
    grep $l tmp1 > $mode.$l.txt
done


