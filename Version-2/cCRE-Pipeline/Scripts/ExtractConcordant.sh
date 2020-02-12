#!/bin/bash

genome=$1

sigDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/signal-output
masterDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific
outputDir=$masterDir/Concordant-Analysis/

list=$masterDir/Master-Cell-List.txt
ccres=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/$genome-ccREs-Unfiltered.bed

j=$SLURM_ARRAY_TASK_ID
mkdir -p /tmp/moorej3/$SLURM_JOBID"-"$j
cd /tmp/moorej3/$SLURM_JOBID"-"$j

group=$(awk '{if (NR == '$j') print $10}' $list)
biosample=$(awk '{if (NR == '$j') print $9}' $list)

if [ $group == "Group1" ]
then
    class="I"
elif [ $group == "Group2" ] || [ $group == "Group3" ] \
    || [ $group == "Group4" ] || [ $group == "Group5" ] || \
    [ $group == "Group6" ] || [ $group == "Group14" ]
then
    class="II"
else
    class="III"
fi

#DNase
d1=$(awk '{if (NR == '$j') print $1}' $list)
d2=$(awk '{if (NR == '$j') print $2}' $list)

if [ $d1 != "---" ] 
then
awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres $sigDir/$d1"-"$d2.txt | \
    awk '{if ($2 > 1.64) print $1 "\t" "'$class'"}' > $d1.DNase.txt
fi

#H3K4me3
d1=$(awk '{if (NR == '$j') print $3}' $list)
d2=$(awk '{if (NR == '$j') print $4}' $list)

if [ $d1 != "---" ] 
then
awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres $sigDir/$d1"-"$d2.txt | \
    awk '{if ($2 > 1.64) print $1 "\t" "'$class'"}' > $d1.H3K4me3.txt
fi

#H3K27ac
d1=$(awk '{if (NR == '$j') print $5}' $list)
d2=$(awk '{if (NR == '$j') print $6}' $list)

if [ $d1 != "---" ] 
then
awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres $sigDir/$d1"-"$d2.txt | \
    awk '{if ($2 > 1.64) print $1 "\t" "'$class'"}' > $d1.H3K27ac.txt
fi

#CTCF
d1=$(awk '{if (NR == '$j') print $7}' $list)
d2=$(awk '{if (NR == '$j') print $8}' $list)

if [ $d1 != "---" ] 
then
awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres $sigDir/$d1"-"$d2.txt | \
    awk '{if ($2 > 1.64) print $1 "\t" "'$class'"}' > $d1.CTCF.txt
fi

if [ $class == "I" ] || [ $class == "II" ]
then
d1=$(awk '{if (NR == '$j') print $1}' $list)
cat *.H3K4me3.txt *.H3K27ac.txt *.CTCF.txt | awk '{print $1}' | sort -u > tmp1
awk 'FNR==NR {x[$1];next} ($1 in x)' *.DNase.txt tmp1 > $d1.concordant.$class.txt
fi

mkdir -p $outputDir
mv *.*.txt $outputDir

rm -r /tmp/moorej3/$SLURM_JOBID"-"$j
