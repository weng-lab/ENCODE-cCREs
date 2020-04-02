SPDX-License-Identifier: MIT
Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#To run:
# ./Supplementary-Fig15h.Cell-Type-Specific-SuRE-Peak-Overlap.sh {mode}
# mode = [K562, myeloid, other]

mode=$1 
sure=SuRE-peaks.bed
dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/Cell-Type-Specific/Seven-Group
dataFile=$mode-dnase.txt

rm -f $mode-*-Output.txt
k=$(wc -l $dataFile | awk '{print $1}') 
for j in $(seq $k)
do
    echo $j
    dnase=$(cat $dataFile | awk -F "\t" '{if (NR == '$j') print $2}')
    biosample=$(cat $dataFile | awk -F "\t" '{if (NR == '$j') print $3}')
    grep -v "Low-DNase" $dataDir/$dnase*bed > tmp.bed
    awk 'FNR==NR {x[$4];next} ($5 in x)' tmp.bed hg38-hg19.bed > tmp19.bed
    B=$(bedtools intersect -wo -a tmp19.bed -b $sure | awk '{sum += ($3-$2)}END{print sum}')
    A=$(awk '{sum += ($3-$2)}END{print sum}' tmp19.bed)
    awk 'BEGIN{print "'$biosample'" "\t" '$B'/'$A'*100 "\t" "'$mode'"}' \
        >> $mode-All-Output.txt

    datasets=("P" "p" "d" )
    for l in ${datasets[@]}
    do
	echo -e "\t" $l
        awk '{if ($NF == "'$l'") print $0}' tmp19.bed > tmpG.bed
        B=$(bedtools intersect -wo -a tmpG.bed -b $sure | awk '{sum += ($3-$2)}END{print sum}')
        A=$(awk '{sum += ($3-$2)}END{print sum}' tmpG.bed)
        awk 'BEGIN{print "'$biosample'" "\t" '$B'/'$A'*100 "\t" "'$mode'"}' \
            >> $mode-$l-Output.txt
    done
done
