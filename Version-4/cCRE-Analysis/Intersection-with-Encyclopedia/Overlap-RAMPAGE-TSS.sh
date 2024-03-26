#Jill Moore
#Moore Lab - UMass Chan
#March 2024

#Usage: ./Overlap-RAMPAGE-TSS.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/S3_Encyclopedia_Overlap/RAMPAGE

cd $workingDir

awk 'FNR==NR {x[$1];next} ($4 in x)' ~/Lab/ENCODE/RAMPAGE/hg38-rPeak-Gene-Assignments.txt \
    ~/Lab/ENCODE/RAMPAGE/hg38-rPeaks.bed > hg38-rPeaks.Linked-Gene.bed
awk '{printf "%s\t%.0f\t%.0f\t%s\n", $1,($3+$2)/2,($3+$2)/2,$4}' \
    ../../../hg38-cCREs-Unfiltered.bed |  \
    bedtools closest -d -a hg38-rPeaks.Linked-Gene.bed -b stdin | \
    awk '{if ($NF < 200) print $4}' | sort -u | wc -l

bedtools intersect -u -a ../../../hg38-cCREs-Unfiltered.bed \
    -b hg38-rPeaks.Linked-Gene.bed | grep "PLS" | wc -l
bedtools intersect -u -a ../../../hg38-cCREs-Unfiltered.bed \
    -b hg38-rPeaks.Linked-Gene.bed | grep "pELS" | wc -l
bedtools intersect -u -a ../../../hg38-cCREs-Unfiltered.bed \
    -b hg38-rPeaks.Linked-Gene.bed | grep "dELS" | wc -l

bedtools intersect -u -a ../../../hg38-cCREs-Unfiltered.bed \
    -b hg38-rPeaks.Linked-Gene.bed | grep "ELS" > \
    Experimentally-Derived.RAMPAGE-Supported.PLS.bed
