#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 14bcd

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

soloQuant=CAPRA-Output/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
doubleQuant=CAPRA-Output/ENCSR661FOW-DESeq2.Double-Pair.V7.txt

soloMatrix=CAPRA-Output/ENCSR661FOW-Matrix.Solo-Filtered.V7.txt
doubleMatrix=CAPRA-Output/ENCSR661FOW-Matrix.Double-Pair.V7.txt

cd $workingDir

for i in `seq 1 1 10`
do
    echo $i
    awk '{if ($2 >= '$i') print $0}' $soloMatrix > tmp.A
    awk '{if ($2 >= '$i') print $0}' $doubleMatrix > tmp.B
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A $soloQuant > tmp.AA
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B $doubleQuant > tmp.BB
    python $scriptDir/Toolkit/match-ccre-pair-quants.py tmp.AA tmp.BB PCC | \
        awk '{print '$i' "\t" $0}' >> Figure-Input-Data/Supplementary-Figure-14b.CAPRA-Solo-Double-PCC.txt
done 

i=1
awk '{if ($2 >= '$i') print $0}' $soloMatrix > tmp.A
awk '{if ($2 >= '$i') print $0}' $doubleMatrix > tmp.B
awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A $soloQuant > tmp.AA
awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B $doubleQuant > tmp.BB
python $scriptDir/Toolkit/match-ccre-pair-quants.py tmp.AA tmp.BB PRINT > \
    Figure-Input-Data/Supplementary-Figure-14c.CAPRA-Solo-Double-Scatter.1.txt

i=10
awk '{if ($2 >= '$i') print $0}' $soloMatrix > tmp.A
awk '{if ($2 >= '$i') print $0}' $doubleMatrix > tmp.B
awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A $soloQuant > tmp.AA
awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B $doubleQuant > tmp.BB
python $scriptDir/Toolkit/match-ccre-pair-quants.py tmp.AA tmp.BB PRINT > \
    Figure-Input-Data/Supplementary-Figure-14d.CAPRA-Solo-Double-Scatter.10.txt

rm tmp.*
