

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry

cd $workingDir

#wget http://catlas.org/catlas_downloads/humanbrain/cCREs/cCREs.bed
#mv cCREs.bed BICCN-All-cCREs.bed

#wget http://catlas.org/catlas_downloads/humanbrain/cCREs/cCREs.collapse.bed
#mv cCREs.collapse.bed BICCN-Unique-cCREs.bed

current=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
previousV2=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Simple.bed
previousV3=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-hg38/hg38-cCREs-Simple.bed

bedtools intersect -c -a BICCN-Unique-cCREs.bed -b $previousV2 | awk '{if ($NF > 0) sum +=1} \
    END{print "All-Cell-Types" "\t" sum "\t" NR "\t" sum/NR}' > tmp.V2

bedtools intersect -c -a BICCN-Unique-cCREs.bed -b $previousV3 | awk '{if ($NF > 0) sum +=1} \
    END{print "All-Cell-Types" "\t" sum "\t" NR "\t" sum/NR}' > tmp.V3

bedtools intersect -c -a BICCN-Unique-cCREs.bed -b $current | awk '{if ($NF > 0) sum +=1} \
    END{print "All-Cell-Types" "\t" sum "\t" NR "\t" sum/NR}' > tmp.V4

cellTypes=$(awk '{print $5}' BICCN-All-cCREs.bed | sort -u )
for cellType in ${cellTypes[@]}
do
    echo $cellType
    awk '{if ($5 == "'$cellType'") print $0}' BICCN-All-cCREs.bed | \
	bedtools intersect -c -a stdin -b $previousV2 | awk '{if ($NF > 0) sum +=1} \
	END{print "'$cellType'" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.V2
    awk '{if ($5 == "'$cellType'") print $0}' BICCN-All-cCREs.bed | \
	bedtools intersect -c -a stdin -b $previousV3 | awk '{if ($NF > 0) sum +=1} \
        END{print sum "\t" NR "\t" sum/NR}' >> tmp.V3
    awk '{if ($5 == "'$cellType'") print $0}' BICCN-All-cCREs.bed | \
        bedtools intersect -c -a stdin -b $current | awk '{if ($NF > 0) sum +=1} \
	END{print sum "\t" NR "\t" sum/NR}' >> tmp.V4
done

paste tmp.V2 tmp.V3 tmp.V4 > Table-Input-Data/Supplementary-Table-4x.BICCN-cCRE-Overlap.txt
rm tmp.V*
