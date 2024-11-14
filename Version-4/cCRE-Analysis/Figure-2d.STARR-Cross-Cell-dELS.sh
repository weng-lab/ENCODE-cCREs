#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Extended-Data-Figure-3a.STARR-Cross-Cell.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

grep dELS $ccres > tmp.ccres
star=ENCSR858MPS
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $1 "\t" $3}' > tmp.col
star=ENCSR135NXN
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $3}' | paste tmp.col - > tmp.matrix

awk '{if ($2 > 0 && $2 > $3+1) print $0}' tmp.matrix | awk '{print $0 "\t" "K562"}' > tmp.results
awk '{if ($3 > 0 && $3 > $2+1) print $0}' tmp.matrix | awk '{print $0 "\t" "HepG2"}' >> tmp.results
awk 'FNR==NR {x[$1];next} !($1 in x)' tmp.results tmp.matrix | awk '{print $0 "\t" "No"}' > tmp.tmp
cat tmp.tmp >> tmp.results

mv tmp.results Figure-Input-Data/Figure-2d.STARR-Cross-Cell-dELS.txt

rm tmp.*
