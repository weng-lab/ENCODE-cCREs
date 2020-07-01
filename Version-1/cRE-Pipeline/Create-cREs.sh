#!/bin/bash 

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated June 2017

genome=mm10
outputDir=/home/jm36w/Lab/Results/V4-$genome/maxZ-Output/
dnaseList=/home/jm36w/Lab/Results/V4-$genome/DNase-List.txt
h3k4me3List=/home/jm36w/Lab/Results/V4-$genome/H3K4me3-List.txt
h3k27acList=/home/jm36w/Lab/Results/V4-$genome/H3K27ac-List.txt
ctcfList=/home/jm36w/Lab/Results/V4-$genome/CTCF-List.txt
rdhs=/home/jm36w/Lab/Results/V4-$genome/$genome-rDHS-FDR3.bed
tss=~/Lab/Reference/Mouse/GencodeM4/TSS.Filtered.4K.bed
signalDir=/home/jm36w/Lab/Results/V4-$genome/signal-output

mkdir -p $outputDir
cd $outputDir

#DNase
j1=$(bsub -J maxZ -q short -R "rusage[mem=1000]" \
   -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
   -W 4:00 /home/jm36w/scratch/Test/Calculate-Max-Zscore.sh $dnaseList \
   $signalDir DNase $genome)
echo $j1

#H3K4me3
j2=$(bsub -J maxZ -q short -R "rusage[mem=1000]" \
   -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
   -W 4:00 /home/jm36w/scratch/Test/Calculate-Max-Zscore.sh $h3k4me3List \
   $signalDir H3K4me3 $genome)
echo $j2

#H3K27ac
j3=$(bsub -J maxZ -q short -R "rusage[mem=1000]" \
   -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
   -W 4:00 /home/jm36w/scratch/Test/Calculate-Max-Zscore.sh $h3k27acList \
   $signalDir H3K27ac $genome)
echo $j3

#CTCF
j4=$(bsub -J maxZ -q short -R "rusage[mem=1000]" \
   -o "/home/jm36w/JobStats/%J.out" -e "/home/jm36w/JobStats/%J.error" \
   -W 4:00 /home/jm36w/scratch/Test/Calculate-Max-Zscore.sh $ctcfList \
   $signalDir CTCF $genome)
echo $j4

sleep 2m

i=$(bjobs | grep "maxZ" | wc -l | awk '{print $1}')
while [ $i -gt 0 ]
do
    sleep 2m
    echo $i
    i=$(bjobs | grep "maxZ" | wc -l | awk '{print $1}')
done

/home/jm36w/scratch/Test/Classify-rDHSs.sh $rdhs $genome-DNase-MaxZ \
    $genome-H3K4me3-MaxZ $genome-H3K27ac-MaxZ $genome-CTCF-MaxZ $tss

/home/jm36w/scratch/Test/Curate-cREs.sh $rdhs $genome

