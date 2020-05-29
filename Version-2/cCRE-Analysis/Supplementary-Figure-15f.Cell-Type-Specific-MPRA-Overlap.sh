SPDX-License-Identifier: MIT
Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#To run:
# ./Supplementary-Fig15f.Cell-Type-Specific-MPRA-Overlap.sh {mode}
# mode = [ldl, lymphoid, other]

mode=$1
activeMPRA=MPRA-hg19-Active.bed
inactiveMPRA=MPRA-hg19-Inactive.bed
dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/Cell-Type-Specific/Seven-Group
dataFile=$mode-dnase.txt
overlap=0.25

rm -f $mode-*-Output.txt
k=$(wc -l $dataFile | awk '{print $1}') 
for j in $(seq $k)
do
    echo $j
    dnase=$(cat $dataFile | awk -F "\t" '{if (NR == '$j') print $2}')
    biosample=$(cat $dataFile | awk -F "\t" '{if (NR == '$j') print $3}')
    grep -v "Low-DNase" $dataDir/$dnase*bed > tmp.bed
    awk 'FNR==NR {x[$4];next} ($5 in x)' tmp.bed hg38-hg19.bed > tmp19.bed
    B=$(bedtools intersect -f $overlap -u -a tmp19.bed -b $activeMPRA | wc -l | awk '{print $1}')
    A=$(bedtools intersect -f $overlap -u -a tmp19.bed -b $inactiveMPRA | wc -l | awk '{print $1}')
    awk 'BEGIN{print "'$biosample'" "\t" '$B'/('$A'+'$B')*100}' >> $mode-All-Output.txt

    datasets=("P" "p" "d" )
    for l in ${datasets[@]}
    do
        awk '{if ($NF == "'$l'") print $0}' tmp19.bed > tmpG.bed
        B=$(bedtools intersect -f $overlap -u -a tmpG.bed -b $activeMPRA | wc -l | awk '{print $1}')
        A=$(bedtools intersect -f $overlap -u -a tmpG.bed -b $inactiveMPRA | wc -l | awk '{print $1}')
        awk 'BEGIN{print "'$biosample'" "\t" '$B'/('$A'+'$B') "\t" '$B' "\t" '$A'}' >> $mode-$l-Output.txt
    done
done
