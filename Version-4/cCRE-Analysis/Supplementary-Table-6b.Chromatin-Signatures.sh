#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Extended-Data-Figure-3a.STARR-Cross-Cell.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

awk '{if ($(NF-1) < 0.05 && $3 > 0) print $1}' Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt | awk 'FNR==NR {x[$1];next} ($1 in x)' - Figure-Input-Data/Supplementary-Figure-6c.CAPRA-Solo-Double-Scatter.1.txt | awk '{if ($2 > $4 && $5 < $2 && $5 < $6 && $4 < 0 && $5 < 0) print $0}' > dom-rep-2.txt
awk '{if ($(NF-1) < 0.05 && $3 > 0) print $1}' Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt | awk 'FNR==NR {x[$1];next} ($3 in x)' - Figure-Input-Data/Supplementary-Figure-6c.CAPRA-Solo-Double-Scatter.1.txt | awk '{if ($2 < $4 && $5 < $4 && $5 < $6 && $2 < 0 && $5 < 0) print $0}' >> dom-rep-2.txt

awk '{if ($2 < 0) print $3; else print $1}' dom-rep-2.txt | sort -u > tmp.2-high

awk '{if ($(NF-1) < 0.05 && $3 > 0) print $1}' Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt | awk 'FNR==NR {x[$1];next} ($3 in x)' - Figure-Input-Data/Supplementary-Figure-6c.CAPRA-Solo-Double-Scatter.1.txt | awk '{print $3}' | awk 'FNR==NR {x[$1];next} !($1 in x)' tmp.2-high - > tmp.other
awk '{if ($(NF-1) < 0.05 && $3 > 0) print $1}' Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt | awk 'FNR==NR {x[$1];next} ($1 in x)' - Figure-Input-Data/Supplementary-Figure-6c.CAPRA-Solo-Double-Scatter.1.txt | awk '{print $1}' | awk 'FNR==NR {x[$1];next} !($1 in x)' tmp.2-high - >> tmp.other

t1=$(wc -l tmp.2-high | awk '{print $1}')
t2=$(wc -l tmp.other | awk '{print $1}')

b1=$(awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.2-high ../../signal-output/ENCSR000AKP-ENCFF849TDM.txt | awk '{if ($2 > 1.64) print $0}' | awk 'FNR==NR {x[$1];next} ($1 in x)' - ../../signal-output/ENCSR000EOT-ENCFF414OGC.txt | awk '{if ($2 > 1.64) print $0}' | wc -l | awk '{print $1}')
b2=$(awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.other ../../signal-output/ENCSR000AKP-ENCFF849TDM.txt | awk '{if ($2 > 1.64) print $0}' | awk 'FNR==NR {x[$1];next} ($1 in x)' - ../../signal-output/ENCSR000EOT-ENCFF414OGC.txt | awk '{if ($2 > 1.64) print $0}' | wc -l | awk '{print $1}')

d1=$(awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.2-high ../../signal-output/ENCSR000EOT-ENCFF414OGC.txt | awk '{if ($2 > 1.64) print $0}' | wc -l | awk '{print $1}')
d2=$(awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.other ../../signal-output/ENCSR000EOT-ENCFF414OGC.txt | awk '{if ($2 > 1.64) print $0}' | wc -l | awk '{print $1}')

echo -e $t1 "\t" $b1 "\t" $d1 "\t" $t2 "\t" $b2 "\t" $d2

rm tmp*
