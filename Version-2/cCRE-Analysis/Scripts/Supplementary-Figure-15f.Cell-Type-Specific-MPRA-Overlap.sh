SPDX-License-Identifier: MIT
Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#To run:
# ./Supplementary-Fig15f.Cell-Type-Specific-MPRA-Overlap.sh {mode}
# mode = [ldl, lymphoid, other]

mode=$1

####Process MPRA regions####
awk '{if ($14 > 2 || $9 >2) print $0}' Table-S1.tsv | awk '{print $1}' | awk -F "_" '{print $1}' | sort -u > active-snp

awk '{if ($14 < 2 && $9 < 2) print $0}' Table-S1.tsv | awk '{print $1}' | awk -F "_" '{print $1}' | sort -u > other-snp

awk 'FNR==NR {x[$1];next} !($1 in x)' active-snp other-snp | sort -u > nonactive-snp


grep "chr" active-snp | awk -F ":" '{print $1 "\t" $2-75 "\t" $2+75 "\t" $0}' > active.bed
grep "chr" nonactive-snp | awk -F ":" '{print $1 "\t" $2-75 "\t" $2+75 "\t" $0}' > nonactive.bed

grep -v "chr" active-snp > list
num=$(wc -l list | awk '{print int($1/100)}')
rm -f snp.bed

for j in `seq 1 1 $num`
do
    count=$(awk 'BEGIN{print '$j'*100}')
    head -n $count list | tail -n 100 > mini
    query=$(awk '{print $1}' mini | sort -u | sed ':a;N;$!ba;s/\n/,/g')
    wget "https://api.wenglab.org/gwasws/snp_coord/hg19/"$query -O text
    awk '{if ($1 !~ /_/) print $1 "\t" $3 "\t" $3 "\t" $4}' text >> \
        snp.bed
done

remainder=$(wc -l list | awk '{print $1-'$num'*100}')
if [ "$remainder" -gt 0 ]
then
    tail -n $remainder list > mini
    query=$(awk '{print $1}' mini | sort -u | sed ':a;N;$!ba;s/\n/,/g')
    wget "https://api.wenglab.org/gwasws/snp_coord/hg19/"$query -O text
    awk '{if ($1 !~ /_/) print $1 "\t" $3 "\t" $3 "\t" $4}' text >> \
        snp.bed
fi

awk '{print $1 "\t" $2-75 "\t" $2+75 "\t" $4}' snp.bed >> active.bed

grep -v "chr" nonactive-snp > list
num=$(wc -l list | awk '{print int($1/100)}')
rm -f snp.bed

for j in `seq 1 1 $num`
do
    count=$(awk 'BEGIN{print '$j'*100}')
    head -n $count list | tail -n 100 > mini
    query=$(awk '{print $1}' mini | sort -u | sed ':a;N;$!ba;s/\n/,/g')
    wget "https://api.wenglab.org/gwasws/snp_coord/hg19/"$query -O text
    awk '{if ($1 !~ /_/) print $1 "\t" $3 "\t" $3 "\t" $4}' text >> \
        snp.bed
done

remainder=$(wc -l list | awk '{print $1-'$num'*100}')
if [ "$remainder" -gt 0 ]
then
    tail -n $remainder list > mini
    query=$(awk '{print $1}' mini | sort -u | sed ':a;N;$!ba;s/\n/,/g')
    wget "https://api.wenglab.org/gwasws/snp_coord/hg19/"$query -O text
    awk '{if ($1 !~ /_/) print $1 "\t" $3 "\t" $3 "\t" $4}' text >> \
        snp.bed
fi

awk '{print $1 "\t" $2-75 "\t" $2+75 "\t" $4}' snp.bed >> nonactive.bed






dataDir=~/Data-Files/
outputDir=~/Output/


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
