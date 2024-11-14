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
groups=(EH38 PLS dELS)

for group in ${groups[@]}
do 

    awk '{if ($2 >= '$i') print $0}' $soloMatrix1 > tmp.A
    awk '{if ($2 >= '$i') print $0}' $soloMatrix2 > tmp.B
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A $soloQuant1 | awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B - > tmp.AA
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.B $soloQuant2 | awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.A - > tmp.BB
    paste tmp.AA tmp.BB | awk '{print $1 "\t" $3 "\t" $10}' | awk '{if ($2 != "NA" && $3 != "NA") print $0}' > tmp.C
    grep $group $ccres | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C > tmp.CC
    n=$(wc -l tmp.CC | awk '{print $1}')
    Rscript $scriptDir/corr-white-reddy.R tmp.CC | awk '{print "'$i'" "\t" $1 "\t" $2 "\t" "'$group'" "\t" "'$n'"}'
    grep $group $k562 | awk 'FNR==NR {x[$4];next} ($5 in x)' - $ccres | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C > tmp.CC
    n=$(wc -l tmp.CC | awk '{print $1}')
    Rscript $scriptDir/corr-white-reddy.R tmp.CC | awk '{print "'$i'" "\t" $1 "\t" $2 "\t" "'$group'-K562" "\t" "'$n'"}'

done

grep PLS $k562 | awk 'FNR==NR {x[$4];next} ($5 in x)' - $ccres | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C | awk 'FNR==NR {x[$1];next} ($4 in x)' - ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered_monoCG-diCG-NormalizedCG.bed | sort -k7,7rg | head -n 100 | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C > top.100
Rscript $scriptDir/corr-white-reddy.R top.100 | awk '{print "'$i'" "\t" $1 "\t" $2 "\t" "Top-100-PLS" "\t" 100}'
grep PLS $k562 | awk 'FNR==NR {x[$4];next} ($5 in x)' - $ccres | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C | awk 'FNR==NR {x[$1];next} ($4 in x)' - ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered_monoCG-diCG-NormalizedCG.bed | sort -k7,7g | head -n 100 | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C > bottom.100
Rscript $scriptDir/corr-white-reddy.R bottom.100 | awk '{print "'$i'" "\t" $1 "\t" $2 "\t" "Bottom-100-PLS" "\t" 100}'
grep dELS $k562 | awk 'FNR==NR {x[$4];next} ($5 in x)' - $ccres | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C | awk 'FNR==NR {x[$1];next} ($4 in x)' - ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered_monoCG-diCG-NormalizedCG.bed | sort -k7,7rg | head -n 500 | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C > top.500
Rscript $scriptDir/corr-white-reddy.R top.500 | awk '{print "'$i'" "\t" $1 "\t" $2 "\t" "Top-500-dELS" "\t" 100}'
grep dELS $k562 | awk 'FNR==NR {x[$4];next} ($5 in x)' - $ccres | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C | awk 'FNR==NR {x[$1];next} ($4 in x)' - ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered_monoCG-diCG-NormalizedCG.bed | sort -k7,7g | head -n 500 | awk 'FNR==NR {x[$4];next} ($1 in x)' - tmp.C > bottom.500
Rscript $scriptDir/corr-white-reddy.R bottom.500 | awk '{print "'$i'" "\t" $1 "\t" $2 "\t" "Bottom-500-dELS" "\t" 100}'


rm tmp.*
