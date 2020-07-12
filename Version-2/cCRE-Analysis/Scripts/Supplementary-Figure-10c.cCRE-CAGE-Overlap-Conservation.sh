#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Calculates conservation across cCREs stratified by overlap with CAGE peaks

#TO RUN:
#./Supplementary-Figure-10c.cCRE-CAGE-Overlap-Conservation.sh

genome=hg38
scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts/
workingDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Conservation
ccres=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Simple.bed
cage=FANTOM_CAT.lv4_stringent.CAGE_cluster.bed
chain=~/Lab/Reference/Human/hg38/hg38ToHg19.over.chain

cd $workingDir/
~/bin/liftOver $ccres $chain tmp.ccres-hg19 tmp.no-map
bedtools intersect -u -a tmp.ccres-hg19 -b $cage > tmp.overlap-hg19
bedtools intersect -v -a tmp.ccres-hg19 -b $cage > tmp.no-overlap-hg19

awk 'FNR==NR {x[$5];next} ($5 in x)' tmp.overlap-hg19 $ccres > tmp.overlap-hg38
awk 'FNR==NR {x[$5];next} ($5 in x)' tmp.no-overlap-hg19 $ccres > tmp.no-overlap-hg38

echo "position" > tmp.results
for i in `seq -250 1 250`
do
    echo $i >> tmp.results
done

groups=(PLS pELS dELS DNase-H3K4me3 CTCF-only)
for group in ${groups[@]}
do
    echo "Processing" $group "..."
    awk '{if ($NF ~ /'$group'/) print $0}' tmp.overlap-hg38 > $group-CAGE.bed
    awk '{if ($NF ~ /'$group'/) print $0}' tmp.no-overlap-hg38 > $group-noCAGE.bed

    modes=(CAGE noCAGE)
    for mode in ${modes[@]}
    do
        echo -e "\t Processing" $mode "..."
        ccres=$workingDir/$group-$mode.bed
        ##Step 1 - Run Majority of cCREs###
        num=$(wc -l $ccres | awk '{print int($1/100)}')
        if [ $num -gt 0 ]
        then

        jobid=$(sbatch --nodes 1 --array=1-$num%25 --mem=1G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
            --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
            $scriptDir/Conservation-Meta-cCRE.sh $group-$mode $genome \
            | awk '{print $4}')
        echo $jobid

        sleep 20
        list=100
        while [ $list -gt 1 ]
        do
            list=$(squeue -j $jobid | wc -l | awk '{print $1}')
            echo -e "jobs still running: $list"
            sleep 10
        done
        fi

        ##Step 2 - Run Remaining cCREs###
        remainder=$(wc -l $ccres | awk '{print $1-'$num'*100}')
        if [ $remainder -gt 0 ]
        then
        jobid=$(sbatch --nodes 1 --mem=1G --time=00:30:00 \
             --output=/home/moorej3/Job-Logs/jobid_%A.output \
             --error=/home/moorej3/Job-Logs/jobid_%A.error \
             $scriptDir/Conservation-Meta-cCRE-Single.sh $group-$mode $remainder $genome \
            | awk '{print $4}')

        sleep 20
        list=100
        while [ $list -gt 1 ]
        do
            list=$(squeue -j $jobid | wc -l | awk '{print $1}')
            echo -e "jobs still running: $list"
            sleep 10
        done
        fi
        
        cd $workingDir/Meta-cCRE/$group-$mode

        for f in phyloP-Vert.*;
        do
            echo $f
            cat final.res | paste - $f | awk '{print $1+$3 "\t" $2+$4}' >tmp; cp tmp final.res
        done
        rm tmp
        mv final.res $group-$mode.summary-phylop-vert
        cd $workingDir/
        awk 'BEGIN{print "'$group-$mode'"}{print $2/$1}' \
            Meta-cCRE/$group-$mode/$group-$mode.summary-phylop-vert > tmp.col
        paste tmp.results tmp.col > tmp.tmp
        mv tmp.tmp tmp.results
    done
done

mv tmp.results Meta-cCRE/hg38-cCRE-Meta-Conservation.CAGE-Overlap.txt
rm tmp.*
