#!/bin/bash

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017


genome=hg19
dataDir=/home/jm36w/Lab/Results/V4-"$genome"
scriptDir=/home/jm36w/Projects/ENCODE/Encyclopedia/Version4/

dnaseFiles=$dataDir/DNase-List.txt
h3k27acFiles=$dataDir/H3K27ac-List.txt
h3k4me3Files=$dataDir/H3K4me3-List.txt
ctcfFiles=$dataDir/CTCF-List.txt
enhancerFiles=$dataDir/Enhancer-List.txt
promoterFiles=$dataDir/Promoter-List.txt
insulatorFiles=$dataDir/Insulator-List.txt
rampageFiles=$dataDir/RAMPAGE-List.txt

cREs=$dataDir/$genome"-rDHS-FDR3.bed"

##Step 1 - Retreive Signal Rank##

num=$(wc -l $dnaseFiles | awk '{print $1}')
dnase=$(bsub -n 1 -J "DNase-Rank[1-$num]" -q short -R "rusage[mem=10000]" \
      -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
      -W 0:30 $scriptDir/Retrieve-Zscore-Signal.sh $peaks 0 $dnaseFiles  \
      $genome | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $dnase

num=$(wc -l $h3k27acFiles | awk '{print $1}')
h3k27ac=$(bsub -n 1 -J "H3K27ac-Rank[1-$num]" -q short -R "rusage[mem=10000]" \
        -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
        -W 0:30 $scriptDir/Retrieve-Zscore-Signal.sh $peaks 500 $h3k27acFiles \
        $genome | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $h3k27ac

num=$(wc -l $h3k4me3Files | awk '{print $1}')
h3k4me3=$(bsub -n 1 -J "H3K27ac-Rank[1-$num]" -q short -R "rusage[mem=10000]" \
        -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
        -W 0:30 $scriptDir/Retrieve-Zscore-Signal.sh $peaks 500 $h3k4me3Files \
        $genome | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $h3k4me3

num=$(wc -l $ctcfFiles | awk '{print $1}')
ctcf=$(bsub -n 1 -J "H3K27ac-Rank[1-$num]" -q short -R "rusage[mem=10000]" \
     -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
     -W 0:30 $scriptDir/Retrieve-Zscore-Signal.sh $peaks 0 $ctcfFiles \
     $genome | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $ctcf

num=$(wc -l $rampageFiles | awk '{print $1}')
rampage=$(bsub -n 1 -J "H3K27ac-Rank[1-$num]" -q short -R "rusage[mem=10000]" \
        -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
        -W 0:30 $scriptDir/Retrieve-Zscore-Signal.sh $peaks 0 $rampageFiles \
        $genome | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $rampage


##Step 2 - Average Rank##

num=$(wc -l $enhancerFiles | awk '{print $1}')
enhancer=$(bsub -n 1 -J "Enhancer-Rank[1-$num]" -q short -R "rusage[mem=10000]" \
         -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
         -W 0:30 $scriptDir/V4.CombineSignal.sh \
         $enhancerFiles | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $enhancer

num=$(wc -l $promoterFiles | awk '{print $1}')
promoter=$(bsub -n 1 -J "Promoter-Rank[1-$num]" -q short -R "rusage[mem=10000]" \
         -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
         -W 0:30 $scriptDir/V4.CombineSignal.sh \
         $promoterFiles | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $promoter

num=$(wc -l $insulatorFiles | awk '{print $1}')
ctcf=$(bsub -n 1 -J "CTCF-Rank[1-$num]%5" -q short -R "rusage[mem=10000]" \
     -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
     -W 0:30 $scriptDir/V4.CombineSignal.sh \
     $insulatorFiles | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $ctcf

##Step 3 - Conservation##

conservation=('phastCons100way.bigWig' 'phastCons46way.bigWig' \
             'phyloP100way.bigWig' 'phyloP46way.bigWig' \
             'phastCons46way.placental.bigWig' 'phyloP46way.placental.bigWig' \
             'Primate.PhastCons.bigwig' 'Primate.PhyloP.bigwig')
for j in $(seq ${#conservation[@]})
do
con=$(bsub -n 1 -J "Conservation" -q short -R "rusage[mem=10000]" \
    -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
    -W 0:30 $scriptDir/V4.Conservation.sh \
    ${conservation[$(($j-1))]} /home/jm36w/Lab/Reference/Human/Conservation \
    $peaks | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $con
done

conservation=('mm10.60way.phastCons60wayPlacental.bw' \
             'mm10.60way.phyloP60wayPlacental.bw' 'mm10.60way.phastCons.bw' \
             'mm10.60way.phyloP60way.bw')
for j in $(seq ${#conservation[@]})
do
con=$(bsub -n 1 -J "Conservation" -q short -R "rusage[mem=10000]" \
    -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
    -W 0:30 $scriptDir/V4.Conservation.sh \
    ${conservation[$(($j-1))]} /home/jm36w/Lab/Reference/Mouse/Conservation \
    $peaks | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')
echo $con
done

