
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
cd $workingDir

group=REST-Enhancers.bed
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/H3K27ac-List.txt
rm -f tmp.results
for j in `seq 1 1 562`
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

awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' tmp.results > Table-Input-Data/Supplementary-Table-X.REST-Enhancer-H3K27ac-Enrichment.txt

inputList=Table-Input-Data/Supplementary-Table-X.REST-Enhancer-H3K27ac-Enrichment.txt
biosampleList=biosample-classification.txt
awk '{print $5/$8 "\t" $0}' $inputList | sort -k1,1rg > tmp.sort

echo -e "tissue" "\t" "ratio" > tmp.col
tissues=(brain blood lung kidney intestine heart skin pancreas)
for tissue in ${tissues[@]}
do
    grep $tissue $biosampleList > tmp.bio
    fraction=$(awk 'FNR==NR {x[$2];next} ($1 in x)' $inputList tmp.bio | \
        wc -l | awk '{print $1/562}')
    head -n 50 tmp.sort > tmp.50
    awk 'FNR==NR {x[$3];next} ($1 in x)' tmp.50 tmp.bio | wc -l | \
	awk '{print "'$tissue'" "\t" ($1/50)/'$fraction'}' >> tmp.col
done

mv tmp.col Table-Input-Data/Supplementary-Table-X.REST-Enhancer-H3K27ac-Enrichment-Organ.txt
rm tmp.*
