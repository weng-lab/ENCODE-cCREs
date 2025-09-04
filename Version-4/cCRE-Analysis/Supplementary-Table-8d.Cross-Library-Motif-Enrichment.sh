#!/bin/bash

scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis//2_Functional-Characterization

capraQuant=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Fragment-Analysis/ENCSR661FOW/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt

pc1G1=CAPRA-Cross-Library-Min10.PC1-Group1.txt
pc1G2=CAPRA-Cross-Library-Min10.PC1-Group2.txt
pc1G3=CAPRA-Cross-Library-Min10.PC1-Group3.txt
pc2G1=CAPRA-Cross-Library-Min10.PC2-Group1.txt
pc2G2=CAPRA-Cross-Library-Min10.PC2-Group2.txt
allTested=CAPRA-Cross-Library-Min10.Matrix.txt

cd $workingDir

totalPC1G1=$(wc -l $pc1G1 | awk '{print $1}')
totalPC1G2=$(wc -l $pc1G2 | awk '{print $1}')
totalPC1G3=$(wc -l $pc1G3 | awk '{print $1}')
totalPC2G1=$(wc -l $pc2G1 | awk '{print $1}')
totalPC2G2=$(wc -l $pc2G2 | awk '{print $1}')
totalAll=$(wc -l $allTested | awk '{print $1-1}')

fimo=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/hg38-cCRE.FIMO.txt
awk 'FNR==NR {x[$2];next} ($2 in x)' $pc1G1 $fimo > tmp.fimo-1
awk 'FNR==NR {x[$2];next} ($2 in x)' $pc1G2 $fimo > tmp.fimo-2
awk 'FNR==NR {x[$2];next} ($2 in x)' $pc1G3 $fimo > tmp.fimo-3
awk 'FNR==NR {x[$2];next} ($2 in x)' $pc2G1 $fimo > tmp.fimo-4
awk 'FNR==NR {x[$2];next} ($2 in x)' $pc2G2 $fimo > tmp.fimo-5
awk 'FNR==NR {x[$1];next} ($2 in x)' $allTested $fimo > tmp.fimo-b


list=/home/moorej3/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/K562-Expressed-Motif.txt
rm -f tmp.results
k=$(wc -l $list | awk '{print $1}')
for i in `seq 1 1 $k`
do
    echo $i
    tf=$(awk '{if (NR == '$i') print $1}' $list)
    G1=$(grep $tf tmp.fimo-1 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    G2=$(grep $tf tmp.fimo-2 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    G3=$(grep $tf tmp.fimo-3 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    G4=$(grep $tf tmp.fimo-4 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    G5=$(grep $tf tmp.fimo-5 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    B=$(grep $tf tmp.fimo-b | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')

    echo -e $tf "\t" $G1 "\t" $totalPC1G1 "\t" $G2 "\t" $totalPC1G2 "\t" $G3 "\t" $totalPC1G3 "\t" $G4 "\t" $totalPC2G1 "\t" $G5 "\t" $totalPC2G2 "\t" $B "\t" $totalAll >> tmp.results
done

python $scriptDir/Toolkit/fisher-test-tf-silencer-enrichment.py tmp.results > ../Table-Input-Data/Supplementary-Table-8d.PCA-Motif-Enrichment.txt
