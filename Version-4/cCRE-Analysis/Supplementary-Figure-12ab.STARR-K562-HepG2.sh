#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Extended-Data-Figure-3a.STARR-Cross-Cell.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

groups=(PLS dELS)
for group in ${groups[@]}
do
    echo $group
    grep $group $ccres > tmp.ccres
    star=ENCSR858MPS
    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
        awk '{print $1 "\t" $3}' > tmp.col
    star=ENCSR135NXN
    awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
        awk '{print $3}' | paste tmp.col - > tmp.$group
done

mv tmp.PLS Figure-Input-Data/Supplementary-Figure-5h.STARR-Cross-Cell-PLS.txt
mv tmp.dELS Figure-Input-Data/Supplementary-Figure-5i.STARR-Cross-Cell-dELS.txt
rm tmp*
