#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#./Supplementary-Figure-1b.Evaluate-Average-Rank.sh {tissue} {peakMethod1} {signalMethod1} {peakMethod2} {signalMethod2}

tissue=$1
peakMethod1=$2
signalMethod1=$3
peakMethod2=$4
signalMethod2=$5

scriptDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Scripts
inputDataDir=~/GitHub/ENCODE-cCREs/Version-2/cCRE-Analysis/Input-Data/mm10

file1=$tissue-$peakMethod1-$signalMethod1.Results.txt
file2=$tissue-$peakMethod2-$signalMethod2.Results.txt

if [ -f "$file1" ] && [ -f "$file2" ]
then
    sort -k5,5rg $file1 | awk 'BEGIN{rank=0; preSig=0}{if ($5 != preSig) rank += 1; \
        print $0 "\t" rank; preSig=$5}' | sort -k1,1 -k2,2n > tmp.1
    sort -k5,5rg $file2 | awk 'BEGIN{rank=0; preSig=0}{if ($5 != preSig) rank += 1; \
        print $0 "\t" rank; preSig=$5}' | sort -k1,1 -k2,2n > tmp.2
    paste tmp.1 tmp.2 | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" 1/(($6+$12)/2)}' > tmp.3
    mv tmp.3 $tissue-AveRank.$peakMethod1-$signalMethod1.$peakMethod2-$signalMethod2.Results.txt
fi


