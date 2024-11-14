#!/bin/bash

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
bigWig=~/Lab/Reference/Human/hg38/Conservation/hg38_240mammal_phyloP.bw


cd $workingDir

#echo "x" > matrix
#for i in `seq -500 1 500`
#do
#    echo $i >> matrix
#done

groups=(V2-V4.Replicated V2-V4.Filtered V2-V4.New Background.No-cCREs)
for group in ${groups[@]}
do
#    ~/bin/randomLines -seed=6921 $workingDir/$group.bed 100000 $workingDir/$group.100k.bed
    bed=$workingDir/$group.100k.bed
#    $scriptDir/Run-Aggregate-Signal.sh $group $workingDir $bigWig $bed
#    paste matrix Output/$group/*.summary > tmp.col
#    mv tmp.col matrix
    awk '{printf "%s\t%.0f\t%.0f\t%s\n", $1,($3+$2)/2-1,($3+$2)/2,$4}' $bed > tmp.center
    ~/bin/bigWigAverageOverBed $bigWig tmp.center tmp.out
    awk '{print $1 "\t" $5 "\t" "'$group'"}' tmp.out > tmp.summary-center
done
#mv matrix $workingDir/Figure-Input-Data/Supplementary-Figure-3c.Version-cCRE-Conservation.txt
mv tmp.summary-center $workingDir/Figure-Input-Data/Supplementary-Figure-3c.Version-cCRE-Conservation.Center.txt

