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

awk '{print $1 "\n" $3}' Figure-Input-Data/Supplementary-Figure-6c.CAPRA-Solo-Double-Scatter.1.txt | sort -u > tmp.tested
awk '{if ($(NF-1) < 0.05 && $3 > 0) print $1}' Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt | \
    awk 'FNR==NR {x[$1];next} ($1 in x)' - tmp.tested | awk 'FNR==NR {x[$1];next} !($1 in x)' tmp.2-high - > tmp.active

list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt
rm -f tmp.results
for j in `seq 1 1 1325`
do
    echo $j
    d=$(awk '{if (NR == '$j') print $1"-"$2}' $list)
    bio=$(awk '{if (NR == '$j') print $3}' $list)
    x1=$(awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.2-high ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
        awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
    x2=$(awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.active ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
        awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
    x3=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
        awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
    echo -e $d "\t" $bio "\t" $x1 "\t" $x2 "\t" $x3 >> tmp.results
done

python $scriptDir/fisher-test-tf-motif-fcc.py tmp.tf > tmp.data

awk '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf "\t%s",$i ; print ""}' tmp.data > Figure-Input-Data/Supplementary-Table-6x.Repressive-Dual-cCRE-TF-Enrichment.txt
mv dom-rep-2.txt Data-Collections/Supplementary-Dataset-X.Repressive-Dual-cCRE-Pairs.txt
rm tmp*
