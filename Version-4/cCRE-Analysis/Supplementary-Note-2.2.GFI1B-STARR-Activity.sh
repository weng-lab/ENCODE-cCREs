#Jill Moore
#Moore Lab - UMass Chan
#November 2023

#Usage: ./Supplementary-Figure-6bcd.CAPRA-Double-Solo-Correlations.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
k562=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/ENCFF414OGC*bed
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

soloQuant1=Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
soloQuant2=White-WG-STARR/ENCSR858MPS-DESeq2.Solo-Filtered.V7.txt

soloMatrix1=Reddy-WG-STARR/ENCSR661FOW-Matrix.Solo-Filtered.V7.txt
soloMatrix2=White-WG-STARR/ENCSR858MPS-Matrix.Solo-Filtered.V7.txt

cd $workingDir

i=10
awk '{if ($2 >= '$i') print $0}' $soloMatrix1 > tmp.A
awk '{if ($2 >= '$i') print $0}' $soloMatrix2 > tmp.B
awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A $soloQuant1 | awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B - > tmp.AA
awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B $soloQuant2 | awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A - > tmp.BB
paste tmp.AA tmp.BB | awk '{print $1 "\t" $3 "\t" $10}' | awk '{if ($2 != "NA" && $3 != "NA") print $0}' > tmp.C
awk 'FNR==NR {x[$2];next} ($1 in x)' ../../Motif/Individual-TFs/GFI1B_HUMAN.H11MO.0.A.FIMO.txt tmp.C | awk '{print $0 "\t" "motif"}' > tmp.CC
awk 'FNR==NR {x[$2];next} !($1 in x)' ../../Motif/Individual-TFs/GFI1B_HUMAN.H11MO.0.A.FIMO.txt tmp.C | awk '{print $0 "\t" "no-motif"}' >> tmp.CC

mv tmp.CC Figure-Input-Data/Supplementary-Note-2.2.GFI1B-Scores-STARR.txt

rm tmp.*
