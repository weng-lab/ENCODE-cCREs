#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 7 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab
#November 2019

#TO RUN:
#./7_Cell-Type-Specific-Seven-Group.sh {genome}

genome=$1
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline

cd ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
python $scriptDir/match.biosamples.py > Cell-Type-Specific/Master-Cell-List.txt
cp ~/Lab/Reference/cres.as Cell-Type-Specific/

files=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific/Master-Cell-List.txt
num=$(wc -l $files | awk '{print $1}')

mkdir -p ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific/Seven-Group
mkdir -p ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific/Nine-State

for j in `seq 1 1 $num`
do
    DNase=$(awk '{if (NR == '$j') print $1}' $files)
    echo $DNase
    if [[ $DNase != "---" ]]
    then
        sbatch --nodes 1 --mem=1G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A.output \
            --error=/home/moorej3/Job-Logs/jobid_%A.error \
            $scriptDir/Split-cCREs.DNase.sh $files $j $genome
    else
        sbatch --nodes 1 --mem=1G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A.output \
            --error=/home/moorej3/Job-Logs/jobid_%A.error \
            $scriptDir/Split-cCREs.NoDNase.sh $files $j $genome
    fi
    /bin/sleep 5
done


