#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#TO RUN:
#./Supplementary-Figure-15e.Tested-Region-Conservation.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-mm10/
testedRegions=$dataDir/Manuscript-Analysis/Transgenic/New-Ranks/Supplementary-Table-22abc.txt
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
conservation=~/Lab/Reference/Mouse/Conservation/mm10.60way.phyloP60way.bw



awk '{if (NR != 1)print $3 "\t" $2 "\t" $4}' $testedRegions | awk '{gsub(/-/,"\t");print}' \
    | awk '{gsub(/:/,"\t");print}' | awk '{if ($NF == "neg") print $1"\t"$2"\t"$3"\t"$4"_"$5; \
    else print $1 "\t" $2 "\t" $3 "\t" $4"_active"}'  > tmp.regions

~/bin/bigWigAverageOverBed $conservation tmp.regions tmp.out
awk '{print $1 "\t" $5}' tmp.out | awk -F "_" '{print $1 "\t" $2}' > Transgenic-Conservation-Summary.txt


