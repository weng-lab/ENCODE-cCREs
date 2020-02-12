genome=$1

rdhs=../$genome-rDHS-Filtered.bed 
summary=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/$genome-rDHS-Filtered-Summary.txt
dhsAll=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase/$genome-DHS-Filtered.bed
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline

cd ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/

mkdir -p maxZ
cp $genome-*-maxZ.txt maxZ
cd maxZ

if [[ $genome == "mm10" ]]
then
prox=~/Lab/Reference/Mouse/GENCODEM18/TSS.Basic.4K.bed
tss=~/Lab/Reference/Mouse/GENCODEM18/TSS.Basic.bed
ChromInfo=~/Lab/Reference/Mouse/ChromInfo.txt
elif [[ $genome == "hg38" ]]
then
prox=~/Lab/Reference/Human/$genome/GENCODE24/TSS.Basic.4K.bed
tss=~/Lab/Reference/Human/$genome/GENCODE24/TSS.Basic.bed
ChromInfo=~/Lab/Reference/Human/hg38/chromInfo.txt
fi

echo "Splitting ccREs into groups..."
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


echo "Accessioning ccREs..."
awk 'FNR==NR {x[$1];next} ($4 in x)' PLS $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "PLS" }' > l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' pELS $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "pELS"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' dELS $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "dELS"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' DNaseK4 $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "DNase-H3K4me3"}' >> l.bed
awk 'FNR==NR {x[$1];next} ($4 in x)' CTCFonly $rdhs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" "CTCF-only"}' >> l.bed

awk 'FNR==NR {x[$4];next} ($1 in x)' l.bed $genome-CTCF-maxZ.txt | \
    awk '{if ($2 > 1.64) print $0}' > CTCFall

awk 'FNR==NR {x[$1];next} ($4 in x)' CTCFall l.bed | \
    awk '{print $0",CTCF-bound"}' > m.bed
awk 'FNR==NR {x[$1];next} !($4 in x)' CTCFall l.bed | \
    awk '{print $0}' >> m.bed

sort -k1,1 -k2,2n m.bed > l.bed

if [[ $genome == "mm10" ]]
then
previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/ccREs.mm10.bed
elif [[ $genome == "hg38" ]]
then
previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/ccREs.hg19-hg38.bed
elif [[ $genome == "hg19" ]]
then
previous=~/Lab/ENCODE/Encyclopedia/Previous-Versions/ccREs.hg19.bed
fi

python $scriptDir/make.region.accession.py l.bed $genome ccRE $previous \
    > $genome-ccREs-Unfiltered.bed
mv $genome-ccREs-Unfiltered.bed ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/
