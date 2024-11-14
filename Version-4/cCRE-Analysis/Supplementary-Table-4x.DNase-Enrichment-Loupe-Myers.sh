
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

current=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
previousV2=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38/hg38-ccREs-Simple.bed
previousV3=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-hg38/hg38-cCREs-Simple.bed

bedtools intersect -v -a Loupe-Myers-TF/union_DLPFC_NEUN.bed -b $previousV3 | \
    bedtools intersect -v -a stdin -b $previousV2 | \
    bedtools intersect -u -b stdin -a $current > tmp.V4

group=tmp.V4
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt
rm -f tmp.results
for j in `seq 1 1 1325`
do
    echo $j
    d=$(awk '{if (NR == '$j') print $1"-"$2}' $list)
    bio=$(awk '{if (NR == '$j') print $3}' $list)
    x1=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $group ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
	awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}') 
    x2=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
	awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}') 
    echo -e $d "\t" $bio "\t" $x1 "\t" $x2 >> tmp.results
done

awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' tmp.results > Table-Input-Data/Supplementary-Table-4x.DNase-Enrichment-Loupe-Myers.txt

rm tmp.*
