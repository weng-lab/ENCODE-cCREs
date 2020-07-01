#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 10 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab

#Script maps human and mouse cCREs over to the other species genome
#and then reports a list of cCREs that have two-way homology

#TO RUN:
#./10_Homologous-ccREs.sh

#Designed to run on Slurm


genome1=hg38
genome2=mm10

version1=V5
version2=V5

chain1=~/Lab/Reference/Human/hg38/hg38ToMm10.over.chain
chain2=~/Lab/Reference/Mouse/mm10ToHg38.over.chain

output=~/Lab/ENCODE/Encyclopedia/$version1/Registry/$version1"-"$genome1/LiftOver
mkdir -p $output

bed1=~/Lab/ENCODE/Encyclopedia/$version1/Registry/$version1"-"$genome1/$genome1-ccREs-Simple.bed
num1=$(wc -l $bed1 | awk 'function ceil(x, y){y=int(x); return(x>y?y+1:y)} \
     {print ceil($1/1000)}')
#1-$num1
jobid=$(sbatch --nodes 1 --array=99 --mem=5G --time=00:30:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    LiftOver.sh $genome1 $version1 $chain1 0.5 $genome2 $output | awk '{print $4}')

echo $jobid

sleep 20
list=100
while [ $list -gt 1 ]
do
list=$(squeue -j $jobid | wc -l | awk '{print $1}')
echo -e "jobs still running: $list"
sleep 10
done

bed2=~/Lab/ENCODE/Encyclopedia/$version2/Registry/$version2"-"$genome2/$genome2-ccREs-Simple.bed
num2=$(wc -l $bed1 | awk 'function ceil(x, y){y=int(x); return(x>y?y+1:y)} \
     {print ceil($1/1000)}')

jobid=$(sbatch --nodes 1 --array=1-$num2 --mem=5G --time=00:30:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    LiftOver.sh $genome2 $version2 $chain2 0.5 $genome1 $output | awk '{print $4}')

echo $jobid

sleep 20
list=100
while [ $list -gt 1 ]
do
list=$(squeue -j $jobid | wc -l | awk '{print $1}')
echo -e "jobs still running: $list"
sleep 10
done

cd ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/LiftOver

rm *NO.txt

cat $genome1"-"$genome2*.txt | sort -u > $genome1"-"$genome2.bed
cat $genome2"-"$genome1*.txt | sort -u > $genome2"-"$genome1.bed

bedtools intersect -wo -a $genome1"-"$genome2.bed -b $bed2 > A
bedtools intersect -wo -b $bed1 -a $genome2"-"$genome1.bed > B

awk 'FNR==NR {x[$5$11];next} ($11$5 in x)' B A | \
    awk '{print $5 "\t" $11}' > $genome1-$genome2-Homologous.txt

mv $genome1-$genome2-Homologous.txt ~/Lab/ENCODE/Encyclopedia/$version1/Registry/$version1"-"$genome1/

