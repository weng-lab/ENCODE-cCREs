
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

group=V2-V4.New.bed
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

awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' tmp.results > Table-Input-Data/Supplementary-Table-4x.DNase-Enrichment-V2-V4-New.txt

inputList=Table-Input-Data/Supplementary-Table-4x.DNase-Enrichment-V2-V4-New.txt
biosampleList=biosample-classification.txt
awk '{print $5/$8 "\t" $0}' $inputList | sort -k1,1rg > tmp.sort

echo -e "tissue" "\t" "ratio" > tmp.col
tissues=(brain blood lung kidney intestine heart skin embryo)
for tissue in ${tissues[@]}
do
    grep $tissue $biosampleList > tmp.bio
    fraction=$(awk 'FNR==NR {x[$2];next} ($1 in x)' $inputList tmp.bio | \
        wc -l | awk '{print $1/1325}')
    head -n 100 tmp.sort > tmp.100
    awk 'FNR==NR {x[$3];next} ($1 in x)' tmp.100 tmp.bio | wc -l | \
	awk '{print "'$tissue'" "\t" ($1/100)/'$fraction'}' >> tmp.col
done

grep -v embryo $biosampleList > tmp.bio
fraction=$(awk 'FNR==NR {x[$2];next} ($1 in x)' $inputList tmp.bio | \
    wc -l | awk '{print $1/1325}')
head -n 100 tmp.sort > tmp.100
awk 'FNR==NR {x[$3];next} ($1 in x)' tmp.100 tmp.bio | wc -l | \
    awk '{print "non-embryo" "\t" ($1/100)/'$fraction'}' >> tmp.col

mv tmp.col Figure-Input-Data/Supplementary-Figure-3x.New-cCRE-DNase-Enrichment.txt
rm tmp.*
