#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024
#Step 6 - Classify cCREs

genome=$1

dataDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome
rdhs=$dataDir/$genome-Anchors.bed 
tfClusters=$dataDir/$genome-TF/$genome-TF-Clusters.txt
scriptDir=~/Projects/ENCODE/Encyclopedia/Version7/cCRE-Pipeline

cd $dataDir

mkdir -p maxZ
cp $genome-*-maxZ.txt maxZ
cd maxZ

if [[ $genome == "mm10" ]]
then
    prox=~/Lab/Reference/Mouse/GENCODEM25/TSS.Basic.4K.bed
    tss=~/Lab/Reference/Mouse/GENCODEM25/TSS.Basic.bed
    ChromInfo=~/Lab/Reference/Mouse/ChromInfo.txt
elif [[ $genome == "hg38" ]]
then
    prox=~/Lab/Reference/Human/$genome/GENCODE40/TSS.Basic.4K.bed
    tss=~/Lab/Reference/Human/$genome/GENCODE40/TSS.Basic.bed
    ChromInfo=~/Lab/Reference/Human/hg38/chromInfo.txt
fi

echo "Splitting cCREs into groups..."
awk '{if ($2 > 1.64) print $0}' $genome-DNase-maxZ.txt > list
awk 'FNR==NR {x[$1];next} ($4 in x)' list $rdhs > bed
bedtools intersect -u -a bed -b $tss > tss
bedtools intersect -v -a bed -b $tss > a1
bedtools intersect -u -a a1 -b $prox | sort -k1,1 -k2,2n > prox
bedtools intersect -v -a bed -b $prox > distal

bedtools closest -d -a prox -b $tss > tmp
python $scriptDir/calculate-center-distance.py tmp agnostic > new
awk '{if ($2 >= -200 && $2 <= 200) print $0}' new > center-distance
awk '{if ($2 < -2000 || $2 > 2000) print $0}' new > far
awk 'FNR==NR {x[$1];next} ($4 in x)' center-distance prox >> tss
awk 'FNR==NR {x[$1];next} ($4 in x)' far prox >> distal
cat center-distance far > new
awk 'FNR==NR {x[$1];next} !($4 in x)' new prox > tmp
mv tmp prox
rm new


###TSS elements###
awk 'FNR==NR {x[$4];next} ($1 in x)' tss $genome-H3K4me3-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' > PLS

awk 'FNR==NR {x[$4];next} ($1 in x)' tss $genome-H3K4me3-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' > no1

awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $genome-H3K27ac-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' > pELS

awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $genome-H3K27ac-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' > no2

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $genome-CTCF-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' > CTCFonly

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $genome-CTCF-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' > CAonly


###Proximal elements###
awk 'FNR==NR {x[$4];next} ($1 in x)' prox $genome-H3K27ac-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' >> pELS

awk 'FNR==NR {x[$4];next} ($1 in x)' prox $genome-H3K27ac-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' > no1

awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $genome-H3K4me3-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' > DNaseK4

awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $genome-H3K4me3-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' > no2

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $genome-CTCF-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' >> CTCFonly

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $genome-CTCF-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' >> CAonly


###Distal elements###
awk 'FNR==NR {x[$4];next} ($1 in x)' distal $genome-H3K27ac-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' > dELS

awk 'FNR==NR {x[$4];next} ($1 in x)' distal $genome-H3K27ac-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' > no1

awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $genome-H3K4me3-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' >> DNaseK4

awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $genome-H3K4me3-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' > no2

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $genome-CTCF-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' >> CTCFonly

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $genome-CTCF-maxZ.txt | \
    awk '{if ($2 <= 1.64) print $0}' >> CAonly

echo "Accessioning ccREs..."
awk 'FNR==NR {x[$1];next} ($4 in x)' PLS $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "PLS" }' > l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' pELS $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "pELS"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' dELS $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "dELS"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' DNaseK4 $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "CA-H3K4me3"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' CTCFonly $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "CA-CTCF"}' >> l.bed

awk 'FNR==NR {x[$1];next} ($4 in x)' CAonly $rdhs > a.bed
bedtools intersect -u -a a.bed -b $tfClusters | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "CA-TF"}' >> l.bed
bedtools intersect -v -a a.bed -b $tfClusters | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "CA"}' >> l.bed

bedtools intersect -u -a $rdhs -b ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/$genome-TF/$genome-TF-Clusters.txt \
    | awk 'FNR==NR {x[$4];next} !($4 in x)' l.bed - > a.bed
awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "TF"}' a.bed >> l.bed

mv l.bed m.bed

sort -k1,1 -k2,2n m.bed > l.bed

if [[ $genome == "mm10" ]]
then
    previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/cCREs.mm10.bed
elif [[ $genome == "hg38" ]]
then
    previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/cCREs.hg38.bed
fi

python $scriptDir/make-region-accession.py l.bed $genome cCRE $previous \
    > $genome-cCREs-Unfiltered.bed
mv $genome-cCREs-Unfiltered.bed $dataDir/
