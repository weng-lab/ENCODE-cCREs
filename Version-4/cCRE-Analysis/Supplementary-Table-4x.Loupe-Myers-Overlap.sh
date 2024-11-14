

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry

cd $workingDir

#wget http://catlas.org/catlas_downloads/humanbrain/cCREs/cCREs.bed
#mv cCREs.bed BICCN-All-cCREs.bed

fileList=Loupe-Myers-TF/List.txt
current=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
previousV2=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Simple.bed
previousV3=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-hg38/hg38-cCREs-Simple.bed

beds=$(ls Loupe-Myers-TF/*bed)

for bed in ${beds[@]}
do
    echo $bed
    bedtools intersect -c -a $bed -b $previousV2 | awk '{if ($NF > 0) sum +=1} \
        END{print "'$bed'" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.V2

    bedtools intersect -c -a $bed -b $previousV3 | awk '{if ($NF > 0) sum +=1} \
        END{print sum "\t" NR "\t" sum/NR}' >> tmp.V3

    bedtools intersect -c -a $bed -b $current | awk '{if ($NF > 0) sum +=1} \
        END{print sum "\t" NR "\t" sum/NR}' >> tmp.V4

done
paste tmp.V2 tmp.V3 tmp.V4 > Table-Input-Data/Supplementary-Table-4x.Loupe-Myers-cCRE-Overlap.txt
rm tmp.V*
