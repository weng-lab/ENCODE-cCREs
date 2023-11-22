#Jill Moore
#Moore Lab - UMass Chan
#November 2023

#Usage: ./Supplementary-Figure-6bcd.CAPRA-Double-Solo-Correlations.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Fragment-Analysis/ENCSR661FOW

for i in `seq 1 1 10`
do
    awk '{if ($2 >= '$i') print $0}' $dataDir/ENCSR661FOW-Matrix.Solo-Filtered.V7.txt > tmp.A
    awk '{if ($2 >= '$i') print $0}' $dataDir/ENCSR661FOW-Matrix.Double-Pair.V7.txt > tmp.B
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A $dataDir/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt > tmp.AA
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B $dataDir/ENCSR661FOW-DESeq2.Double-Pair.V7.txt > tmp.BB
    python match-ccre-pair-quants.py tmp.AA tmp.BB PCC | \
        awk '{print '$i' "\t" $0}'
done 

for i in `seq 1 9 10`
do
    awk '{if ($2 >= '$i') print $0}' $dataDir/ENCSR661FOW-Matrix.Solo-Filtered.V7.txt > tmp.A
    awk '{if ($2 >= '$i') print $0}' $dataDir/ENCSR661FOW-Matrix.Double-Pair.V7.txt > tmp.B
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A $dataDir/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt > tmp.AA
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B $dataDir/ENCSR661FOW-DESeq2.Double-Pair.V7.txt > tmp.BB
    python match-ccre-pair-quants.py tmp.AA tmp.BB PRINT > Summary.$i.txt
done 

rm tmp.*
