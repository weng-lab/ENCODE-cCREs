#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Script calculates overlap between FANTOM CAT TSSs and cCREs

#TO RUN:
#./Supplementary-Figure-17a.Overlap-RBC-MPRA.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38
ccres=$dataDir/hg38-ccREs-Simple.bed
ccresK562=$dataDir/Cell-Type-Specific/Seven-Group/ENCFF971AHO_ENCFF847JMY_ENCFF779QTH_ENCFF405AYC.7group.bed

workingDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/Manuscript-Analysis/RBC-MPRA
tableS1=$workingDir/Ulirsch-2016.Table-S1.txt
tableS2=$workingDir/Ulirsch-2016.Table-S2.txt
chain=~/Lab/Reference/Human/hg38/hg38ToHg19.over.chain

awk -F "\t" '{if (NR != 1) print $1}' $tableS1 | awk -F ":" '{print "chr"$1 "\t" $2 "\t" $2}' | sort -u > tmp.all
awk -F "\t" '{if (NR != 1) print "chr"$5 "\t" $6 "\t" $6}' $tableS2 | sort -u > tmp.active
awk 'FNR==NR {x[$0];next} !($0 in x)' tmp.active tmp.all > tmp.inactive

~/bin/liftOver -bedPlus=9 $ccres $chain tmp.ccres-hg19 tmp.no-map
grep -v "Low-DNase" $ccresK562 > tmp.k562
~/bin/liftOver -bedPlus=9 tmp.k562 $chain tmp.k562-hg19 tmp.no-map

tP=$(wc -l tmp.active | awk '{print $1}')
tN=$(wc -l tmp.inactive | awk '{print $1}')

echo "intersecting elements..."
oPA=$(bedtools intersect -u -a tmp.active -b tmp.ccres-hg19 | wc -l | awk '{print $1}')
oNA=$(bedtools intersect -u -a tmp.inactive -b tmp.ccres-hg19 | wc -l | awk '{print $1}')

oPK=$(bedtools intersect -u -a tmp.active -b tmp.k562-hg19 | wc -l | awk '{print $1}')
oNK=$(bedtools intersect -u -a tmp.inactive -b tmp.k562-hg19 | wc -l | awk '{print $1}')

awk 'BEGIN{print "all cCREs MPRA +: " "'$oPA'" "\t" '$tP'-'$oPA' "\t" '$oPA'/'$tP'}'
awk 'BEGIN{print "all cCREs MPRA -: " "'$oNA'" "\t" '$tN'-'$oNA' "\t" '$oNA'/'$tN'}'

awk 'BEGIN{print "K562 cCREs MPRA +: " "'$oPK'" "\t" '$tP'-'$oPK' "\t" '$oPK'/'$tP'}'
awk 'BEGIN{print "K562 cCREs MPRA -: " "'$oNK'" "\t" '$tN'-'$oNK' "\t" '$oNK'/'$tN'}'

rm tmp.*
