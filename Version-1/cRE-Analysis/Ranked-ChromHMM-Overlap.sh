#!/bin/bash
#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated June 2017

module load bedtools/2.25.0

d=$1

scriptDir=~/Projects/ENCODE/Scripts
dataDir=~/Lab/Results/V4-hg19
bedDir=~/Lab/Results/V4-hg19/maxZ/Cell-Type-Specific/Bed-BigBed
header="group\ttss\tbivalent-tss\tstrong-enhancer\tweak-enhancer\
       \ttranscription\trepressed\tinsulator"

hset=$(grep $d Data-Files.txt | awk -F "\t" '{print $3}')
hsig=$(grep $d Data-Files.txt | awk -F "\t" '{print $4}')
chromHMM=$(grep $d Data-Files.txt | awk -F "\t" '{print $10}')

grep "255,0,0" $bedDir/*$hsig*.bed > tmp

awk 'FNR==NR {x[$4];next} ($5 in x)' tmp $dataDir/hg19-cREs-Simple.bed \
    | sort -k4,4 > rdhs
awk 'FNR==NR {x[$4];next} ($1 in x)' rdhs $dataDir/signal-output/$hset-$hsig.txt \
    | sort -k1,1 | awk '{print $1 "\t" $2}' > signal
paste rdhs signal | sort -k8,8rg > sorted

echo -e $header > $d-promoter-like.txt
max=$(wc -l sorted | awk '{print $1}')
for k in `seq 1000 1000 $max`
do
head -n $k sorted | tail -n 1000 > tmp
bedtools intersect -wo -a $chromHMM.bed -b tmp > tmp2
python $scriptDir/choose.majority.state.py tmp2 13 4 18 > tmp3
A=$(awk '{if ($2 == "1_Active_Promoter" || $2 == "2_Weak_Promoter") print $0}' \
  tmp3 | wc -l | awk '{print $1/1000}')
B=$(awk '{if ($2 == "3_Poised_Promoter") print $0}' tmp3 | wc -l | \
  awk '{print $1/1000}')
C=$(awk '{if ($2 == "4_Strong_Enhancer" || $2 == "5_Strong_Enhancer") \
  print $0}' tmp3 | wc -l | awk '{print $1/1000}')
D=$(awk '{if ($2 == "6_Weak_Enhancer" || $2 == "7_Weak_Enhancer") print $0}' \
  tmp3 | wc -l | awk '{print $1/1000}')
E=$(awk '{if ($2 == "8_Insulator") print $0}' tmp3 | wc -l | awk \
  '{print $1/1000}')
F=$(awk '{if ($2 == "9_Txn_Transition" || $2 == "10_Txn_Elongation" || \
  $2 == "11_Weak_Txn") print $0}' tmp3 | wc -l | awk '{print $1/1000}')
G=$(awk '{if ($2 == "12_Repressed" || $2 == "13_Heterochrom/lo" || \
  $2 == "14_Repetitive/CNV" || $2 == "15_Repetitive/CNV") print $0}' tmp3 \
  | wc -l | awk '{print $1/1000}')
echo -e $k "\t" $A "\t" $B "\t" $C "\t" $D "\t" $E "\t" $G "\t" $F
done >> $d-promoter-like.txt

hset=$(grep $d Data-Files.txt | awk -F "\t" '{print $5}')
hsig=$(grep $d Data-Files.txt | awk -F "\t" '{print $6}')
grep "255,205,0" $bedDir/*$hsig*.bed > tmp

awk 'FNR==NR {x[$4];next} ($5 in x)' tmp $dataDir/hg19-cREs-Simple.bed \
    | sort -k4,4 > rdhs
awk 'FNR==NR {x[$4];next} ($1 in x)' rdhs $dataDir/signal-output/$hset-$hsig.txt \
    | sort -k1,1 | awk '{print $1 "\t" $2}' > signal
paste rdhs signal | sort -k8,8rg > sorted
echo -e $header > $d-enhancer-like.txt
max=$(wc -l sorted | awk '{print $1}')
for k in `seq 1000 1000 $max`
do
head -n $k sorted | tail -n 1000 > tmp
bedtools intersect -wo -a $chromHMM.bed -b tmp > tmp2
python $scriptDir/choose.majority.state.py tmp2 13 4 18 > tmp3
A=$(awk '{if ($2 == "1_Active_Promoter" || $2 == "2_Weak_Promoter") print $0}' \
  tmp3 | wc -l | awk '{print $1/1000}')
B=$(awk '{if ($2 == "3_Poised_Promoter") print $0}' tmp3 | wc -l | \
  awk '{print $1/1000}')
C=$(awk '{if ($2 == "4_Strong_Enhancer" || $2 == "5_Strong_Enhancer") \
  print $0}' tmp3 | wc -l | awk '{print $1/1000}')
D=$(awk '{if ($2 == "6_Weak_Enhancer" || $2 == "7_Weak_Enhancer") print $0}' \
  tmp3 | wc -l | awk '{print $1/1000}')
E=$(awk '{if ($2 == "8_Insulator") print $0}' tmp3 | wc -l | awk \
  '{print $1/1000}')
F=$(awk '{if ($2 == "9_Txn_Transition" || $2 == "10_Txn_Elongation" || \
  $2 == "11_Weak_Txn") print $0}' tmp3 | wc -l | awk '{print $1/1000}')
G=$(awk '{if ($2 == "12_Repressed"m || $2 == "13_Heterochrom/lo" || \
  $2 == "14_Repetitive/CNV" || $2 == "15_Repetitive/CNV") print $0}' tmp3 \
  | wc -l | awk '{print $1/1000}')
echo -e $k "\t" $A "\t" $B "\t" $C "\t" $D "\t" $E "\t" $G "\t" $F
done >> $d-enhancer-like.txt

rm tmp tmp2 tmp3 sorted rdhs signal
