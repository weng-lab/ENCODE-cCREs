#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Extended-Data-Figure-3a.STARR-Cross-Cell.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

grep dELS $ccres > tmp.dels
group=tmp.dels
tfs=(GATA1 FOXA1 P53 GFI1B)
for tf in ${tfs[@]}
do
    awk 'FNR==NR {x[$2];next} ($4 in x)' $tfDir/$tf"_HUMAN.H11MO"*txt $group > tmp.ccres
    stars=(ENCSR858MPS ENCSR135NXN ENCSR064KUD ENCSR547SBZ) 
    for star in ${stars[@]}
    do
	echo $star
        awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
	    awk '{print $1 "\t" $3 "\t" "'$star'" "\t" "'$tf'"}' >> tmp.data
    done
done
mv tmp.data Figure-Input-Data/Extended-Data-Figure-3a.cCRE-STARR-Activity-TEST.txt
rm tmp*
