#Jill E. Moore
#Moore Lab - UMass Chan
#ENCODE4 cCRE Pipeline
#December 2024
#Step 3 - Curate TF Clusters

genome=$1
version=V7
scriptDir1=~/Projects/ENCODE/Encyclopedia/Version7/Curate-Data
scriptDir2=~/Projects/ENCODE/Encyclopedia/Version7/cCRE-Pipeline
rdhs=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/$genome-rDHS/$genome-rDHS-Filtered.bed

mkdir -p ~/Lab/ENCODE/Encyclopedia/$version/Registry/$version-$genome/$genome-TF
cd ~/Lab/ENCODE/Encyclopedia/$version/Registry/$version-$genome/$genome-TF

echo "Curating TF experiments ..."
python3 $scriptDir1/pull-tf-experiments.py $genome > $genome-TF-List.All.txt
awk -F "\t" '{if ($5 > 0.003 && $2 != "NA") print $0}' $genome-TF-List.All.txt \
    > $genome-TF-List.Filtered.txt

num=$(wc -l $genome-TF-List.Filtered.txt | awk '{print $1}')
rm -f tmp.bed

echo "Concatenating TF peaks ..."
for j in `seq 1 1 $num`
do
    echo $j
    exp=$(awk -F "\t" '{if (NR == '$j') print $1}' $genome-TF-List.Filtered.txt)
    peak=$(awk -F "\t" '{if (NR == '$j') print $2}' $genome-TF-List.Filtered.txt)
    target=$(awk -F "\t" '{if (NR == '$j') print $4}' $genome-TF-List.Filtered.txt)
    biosample=$(awk -F "\t" '{if (NR == '$j') print $3}' $genome-TF-List.Filtered.txt)

if test -f "/data/projects/encode/data/$exp/$peak.bed.gz"
then
    cp /data/projects/encode/data/$exp/$peak.bed.gz bed.gz
else
    wget https://www.encodeproject.org/files/$peak/@@download/$peak.bed.gz
    mv $peak.bed.gz bed.gz
fi
    gunzip bed.gz
    awk -v var="$biosample" '{if ($3-$2 < 150) print $1 "\t" $2+$10-75 "\t" $2+$10+75 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" "'$exp'" "\t" "'$target'" "\t" var "\t" "'$exp'-"NR; 
	else if ($3-$2 > 350) print $1 "\t" $2+$10-175 "\t" $2+$10+175 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" "'$exp'" "\t" "'$target'" "\t" var "\t" "'$exp'-"NR; 
	else print $0 "\t" "'$exp'" "\t" "'$target'" "\t" var "\t" "'$exp'-"NR}' bed >> tmp.bed
    rm bed
done

awk '{if ($1 !~ /_/) print $0}' tmp.bed | grep -v "chrEBV" | grep -v "chrM" | sort -k1,1 -k2,2n > tmp.sorted

rm -f tmp.rPeaks
num=$(wc -l tmp.sorted | awk '{print $1}')

echo -e "Merging TF peaks..."
while [ $num -gt 0 ]
do
    echo -e "\t" $num
    bedtools merge -i tmp.sorted -c 14,7 -o collapse,collapse > tmp.merge
    python3 $scriptDir2/pick-best-peak.py tmp.merge > tmp.peak-list
    awk -F "\t" 'FNR==NR {x[$1];next} ($14 in x)' tmp.peak-list tmp.sorted >> tmp.rPeaks
    bedtools intersect -v -a tmp.sorted -b tmp.rPeaks > tmp.remaining
    mv tmp.remaining tmp.sorted
    num=$(wc -l tmp.sorted | awk '{print $1}')
done

awk -F "\t" '{print $1 "\t" $2+$10 "\t" $2+$10+1 "\t" $4 "\t" $5 "\t" $6 \
    "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14}' \
    tmp.bed > tmp.summits

bedtools intersect -wo -a tmp.rPeaks -b tmp.summits > tmp.intersection
python3 $scriptDir2/filter-tf-rpeaks.py tmp.intersection > tmp.out
bedtools intersect -v -a tmp.out -b $rdhs > tmp.no-overlap

python3 $scriptDir2/make-region-accession.py tmp.no-overlap $genome TF > $genome-rTFBS-Summary.txt
awk '{print $1 "\t" $2 "\t" $3 "\t" $NF}' $genome-rTFBS-Summary.txt > $genome-rTFBS.bed
mv tmp.out $genome-TF-Clusters.txt

#rm tmp.*
