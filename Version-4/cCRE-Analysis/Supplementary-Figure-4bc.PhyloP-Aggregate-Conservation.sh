#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 4bc


workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Conservation
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
bigWig1=~/Lab/Reference/Human/hg38/Conservation/hg38.phyloP100way.bw
bigWig2=~/Lab/Reference/Human/hg38/Conservation/hg38_240mammal_phyloP.bw
outputDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

classes=$(awk '{print $NF}' $ccres | sort -u )
for class in ${classes[@]}
do
    awk '{if ($NF == "'$class'") print $1 "\t" $2 "\t" $3 "\t" $4}' $ccres > $class.Full.bed
    total=$(wc -l $class.Full.bed | awk '{print $1}')
    if [ $total -gt 250000 ]
    then
        ~/bin/randomLines -seed=6921 $class.Full.bed 250000 $class.Run.bed
    else
        mv $class.Full.bed $class.Run.bed
    fi
done

cp ../Background.No-cCREs.100k.bed Background.No-cCREs.Run.bed

echo "x" > matrix
for i in `seq -500 1 500`
do
    echo $i >> matrix
done

groups=$(ls *Run.bed | awk -F ".bed" '{print $1}')
for group in ${groups[@]}
do
    echo $group
    $scriptDir/Toolkit/Run-Aggregate-Signal.sh $group $workingDir $bigWig1 $workingDir/$group.bed
    paste matrix Output/$group/*.summary > tmp.col
    mv tmp.col matrix
    echo "Processing center"
    awk '{printf "%s\t%.0f\t%.0f\t%s\n", $1,($3+$2)/2-1,($3+$2)/2,$4}' $workingDir/$group.bed > tmp.center
    ~/bin/bigWigAverageOverBed $bigWig1 tmp.center tmp.out
    awk '{print $1 "\t" $5 "\t" "'$group'"}' tmp.out > tmp.summary-center
done
mv matrix $outputDir/Figure-Input-Data/Supplementary-Figure-4b.cCRE-Class-Vertebrate-Conservation.txt
mv tmp.summary-center $outputDir/Figure-Input-Data/Supplementary-Figure-4b.cCRE-Class-Vertebrate-Conservation.Center.txt

echo "x" > matrix
for i in `seq -500 1 500`
do
    echo $i >> matrix
done

groups=$(ls *Run.bed | awk -F ".bed" '{print $1}')
for group in ${groups[@]}
do
    echo $group
    $scriptDir/Toolkit/Run-Aggregate-Signal.sh $group $workingDir $bigWig2 $workingDir/$group.bed
    paste matrix Output/$group/*.summary > tmp.col
    mv tmp.col matrix
    echo "Processing center"
    awk '{printf "%s\t%.0f\t%.0f\t%s\n", $1,($3+$2)/2-1,($3+$2)/2,$4}' $workingDir/$group.bed > tmp.center
    ~/bin/bigWigAverageOverBed $bigWig2 tmp.center tmp.out
    awk '{print $1 "\t" $5 "\t" "'$group'"}' tmp.out > tmp.summary-center
done
mv matrix $outputDir/Figure-Input-Data/Supplementary-Figure-4c.cCRE-Class-Mammal-Conservation.txt
mv tmp.summary-center $outputDir/Figure-Input-Data/Supplementary-Figure-4c.cCRE-Class-Mammal-Conservation.Center.txt
