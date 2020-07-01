#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017

#This script is designed to run on UMass GHPCC (LSF Queue)
#Script for creating Jaccard Matrix for cRE Clustering Analysis

#BSUB -L /bin/bash
#BSUB -n 1
#BSUB -R rusage[mem=10000] # ask for memory
#BSUB -q short 
#BSUB -o "/home/jm36w/JobStats/%J.out"
#BSUB -e "/home/jm36w/JobStats/%J.error"
#BSUB -W 2:00
#BSUB -J "Process-Control[1-72]"

source ~/.bashrc

genome=mm10
files=h3k4me3-embryo
cres=/home/jm36w/Lab/Results/V4-$genome/$genome-cREs-Simple.bed
outputDir=/home/jm36w/Lab/Results/V4-$genome/signal-output

cd /home/jm36w/Lab/Results/V4-$genome/
j=$LSB_JOBINDEX
num=$(wc -l $files | awk '{print $1}')
experiment=$(awk -F "\t" '{if (NR=='$j') print $1}' $files)
signal=$(awk -F "\t" '{if (NR=='$j') print $2}' $files)
tissue=$(awk -F "\t" '{if (NR=='$j') print $2}' $files)
signalFile=$outputDir/$experiment"-"$signal.txt

awk 'FNR==NR {x[$4];next} ($1 in x)' $cres $signalFile > $j.1.sig
echo $tissue > col.$j

for i in $(seq $num)
do
experiment=$(awk -F "\t" '{if (NR=='$i') print $1}' $files)
signal=$(awk -F "\t" '{if (NR=='$i') print $2}' $files)
signalFile=$outputDir/$experiment"-"$signal.txt
awk 'FNR==NR {x[$4];next} ($1 in x)' $cres $signalFile > $j.2.sig
python ~/scratch/Test/calculate-jaccard.py \
    $j.1.sig $j.2.sig >> col.$j
done

