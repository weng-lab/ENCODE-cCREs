#!/bin/bash

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated May 2017

#This pipeline is designed to run on UMass GHPCC (LSF Queue)

# To run:
# ./Run-Calculate-Saturation.sh N
# N= number of randomly selected datasets [1-21]
# mode = [promoter, enhancer, ctcf], if no mode is selected, inactive cREs will be used

###

file=/home/jm36w/Lab/Results/V4-hg19/maxZ/Cell-Type-Specific/All.txt
N=$1
mode="promoter"

####

j1=$(bsub -J Saturation_$N[1-100] -q short -R "rusage[mem=10000]" -o "/home/jm36w/JobStats/%J.%I.out" -e "/home/jm36w/JobStats/%J.%I.error" -W 4:00 /home/jm36w/Projects/ENCODE/Encyclopedia/Version4/Calculate-cRE-Saturation.sh $N $file | awk -F ">" '{print $1}' | awk -F "<" '{print $2}')

