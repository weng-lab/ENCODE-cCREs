#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Extended-Data-Figure-3a.STARR-Cross-Cell.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

group=tmp.K562
tf=GATA1
awk 'FNR==NR {x[$2];next} ($1 in x)' $tfDir/$tf"_HUMAN.H11MO"*txt $group > tmp.ccres
rm -f tmp.data
stars=(ENCSR858MPS ENCSR135NXN ENCSR064KUD ENCSR547SBZ)
for star in ${stars[@]}
do
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
        awk '{print $1 "\t" $3 "\t" "'$star'" "\t" "'$tf'"}' >> tmp.data
done

group=tmp.HepG2
tfs=(FOXA1 P53 GFI1B)
for tf in ${tfs[@]}
do
    awk 'FNR==NR {x[$2];next} ($1 in x)' $tfDir/$tf"_HUMAN.H11MO"*txt $group > tmp.ccres
    stars=(ENCSR858MPS ENCSR135NXN ENCSR064KUD ENCSR547SBZ) 
    for star in ${stars[@]}
    do
	echo $star
        awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
	    awk '{print $1 "\t" $3 "\t" "'$star'" "\t" "'$tf'"}' >> tmp.data
    done
done
mv tmp.data Figure-Input-Data/TEST.cCRE-STARR-Activity.txt
rm tmp*
