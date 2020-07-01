#!/bin/bash

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017

#./Mouse-ChrommHMM-Overlap.sh Data-Files.txt

files=$1

l=$(wc -l $files | awk '{print $1}')
for j in $(seq $l)
do
    echo $j
    #Promoter
    experiment=$(awk -F "\t" '{if (NR=='$j') print $1}' $files)
    tissue=$(awk -F "\t" '{if (NR=='$j') print $2}' $files)
    
    grep "255,0,0" ~/Lab/Results/V4-mm10/maxZ/Cell-Type-Specific/Bed-BigBed/$experiment*.bed > promoter.bed
    bedtools intersect -wo -a promoter.bed -b Junko/$tissue"_mm10_15_segments.bed" > tmp
    python /home/jm36w/Projects/ENCODE/Scripts/choose.majority.state.py tmp 4 13 14 > tmp3
    
    count=$(wc -l tmp3 | awk '{print $1}')
    
    #TSS & Flanking
    A=$(awk '{if ($2 == "E8" || $2 == "E7" || $2 == "E9") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #TSS Bivalent
    B=$(awk '{if ($2 == "E11") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Transcription
    C=$(awk '{if ($2 == "E1" || $2 == "E2") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Enhancer
    D=$(awk '{if ($2 == "E6" || $2 == "E4" || $2 == "E5") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Weak Enhancer
    E=$(awk '{if ($2 == "E10" || $2 == "E3") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Repressed
    F=$(awk '{if ($2 == "E12" || $2 == "E15" || $2 == "E13" || $2 == "E14") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    G=$(awk 'BEGIN{print '$A'+'$B'+'$C'+'$D'+'$E'+'$F'}')
    echo -e $tissue "\t" $A "\t" $B "\t" $C "\t" $D "\t" $E "\t" $F "\t" $G
    
    #Enhancer
    grep "255,205,0" ~/Lab/Results/V4-mm10/maxZ/Cell-Type-Specific/Bed-BigBed/$experiment*.bed > enhancer.bed
    bedtools intersect -wo -a enhancer.bed -b Junko/$tissue"_mm10_15_segments.bed" > tmp
    python /home/jm36w/Projects/ENCODE/Scripts/choose.majority.state.py tmp 4 13 14 > tmp3
    
    count=$(wc -l tmp3 | awk '{print $1}')
    
    #TSS & Flanking
    A=$(awk '{if ($2 == "E8" || $2 == "E7" || $2 == "E9") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #TSS Bivalent
    B=$(awk '{if ($2 == "E11") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Transcription
    C=$(awk '{if ($2 == "E1" || $2 == "E2") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Enhancer
    D=$(awk '{if ($2 == "E6" || $2 == "E4" || $2 == "E5") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Weak Enhancer
    E=$(awk '{if ($2 == "E10" || $2 == "E3") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    #Repressed
    F=$(awk '{if ($2 == "E12" || $2 == "E15" || $2 == "E13" || $2 == "E14") print $0}' tmp3 | wc -l | awk '{print $1/'$count'}')
    G=$(awk 'BEGIN{print '$A'+'$B'+'$C'+'$D'+'$E'+'$F'}')
    echo -e $tissue "\t" $A "\t" $B "\t" $C "\t" $D "\t" $E "\t" $F "\t" $G
done
