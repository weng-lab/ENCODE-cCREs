#!/bin/bash

scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/TF-Enrichment

tfList=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-TF/hg38-TF-List.Filtered-K562.txt

capraQuant=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Fragment-Analysis/ENCSR661FOW/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
silencer1=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/STARR-Silencers.Stringent.bed
silencer2=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/STARR-Silencers.Robust.bed
control1=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/ENCSR661FOW-Active-1.bed
control2=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/ENCSR661FOW-Neutral.bed
ccres=../../../hg38-cCREs-Unfiltered.bed

cd $workingDir

#make controls

awk '{if ($(NF-1) < 0.01) print $0}' $capraQuant | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - $ccres > $control1


low=-0.04753247 #45th percentile
high=0.01608335 #55th percentile
awk '{if ($3 < '$high' && $3 > '$low') print $0}' $capraQuant | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - $ccres > $control2

totalS1=$(wc -l $silencer1 | awk '{print $1}')
totalS2=$(wc -l $silencer2 | awk '{print $1}')
totalC1=$(wc -l $control1 | awk '{print $1}')
totalC2=$(wc -l $control2 | awk '{print $1}')

fimo=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/hg38-cCRE.FIMO.txt
awk 'FNR==NR {x[$4];next} ($2 in x)' $silencer1 $fimo > tmp.fimo-s1
awk 'FNR==NR {x[$4];next} ($2 in x)' $silencer2 $fimo > tmp.fimo-s2
awk 'FNR==NR {x[$4];next} ($2 in x)' $control1 $fimo > tmp.fimo-c1
awk 'FNR==NR {x[$4];next} ($2 in x)' $control2 $fimo > tmp.fimo-c2


list=/home/moorej3/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/K562-Expressed-Motif.txt
rm -f tmp.results
k=$(wc -l $list | awk '{print $1}')
for i in `seq 1 1 $k`
do
    tf=$(awk '{if (NR == '$i') print $1}' $list)
    S1=$(grep $tf tmp.fimo-s1 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    S2=$(grep $tf tmp.fimo-s2 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    C1=$(grep $tf tmp.fimo-c1 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    C2=$(grep $tf tmp.fimo-c2 | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    echo -e $tf "\t" $tf "\t" $tf "\t" $S1 "\t" $totalS1 "\t" $S2 "\t" $totalS2 "\t" $C1 "\t" $totalC1 "\t" $C2 "\t" $totalC2 >> tmp.results
done

python $scriptDir/fisher-test-tf-silencer-enrichment.py tmp.results > ../Table-Input-Data/Supplementary-Table-8b.Silencer-Motif-Enrichment.txt
