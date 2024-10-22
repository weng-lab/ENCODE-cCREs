
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
cd $workingDir

group=Silencer-cCREs.bed
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

python $scriptDir/group-biosamples.py ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt > tmp
paste Table-Input-Data/Supplementary-Table-7X.Silencer-DNase-Enrichment.txt tmp > Figure-Input-Data/Extended-Data-Figure-6de.Silencer-DNase-Enrichment.txt

tissues=(kidney lung muscle brain)
for tissue in ${tissues[@]}
do
    echo $tissue
    grep $tissue ../1_Updated-Registry/biosample-classification.txt | \
	awk 'FNR==NR {x[$1];next} ($2 in x)' - Figure-Input-Data/Extended-Data-Figure-6de.Silencer-DNase-Enrichment.txt | \
        grep tissue | awk '{print $0 "\t" "'$tissue'"}'>> tmp.selection
done

rm -f tmp.results
for j in `seq 1 1 397`
do
    echo $j
    d=$(awk '{if (NR == '$j') print $1"-"$2}' $list)
    bio=$(awk '{if (NR == '$j') print $3}' $list)
    x1=$(awk 'FNR==NR {x[$4];next} ($1 in x)' REST-Silencers.bed ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
        awk 'BEGIN{sum=0}{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
    x2=$(awk 'FNR==NR {x[$4];next} ($1 in x)' $ccres ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/signal-output/$d.txt | \
        awk '{if ($2 > 1.64) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
    echo -e $d "\t" $bio "\t" $x1 "\t" $x2 >> tmp.results
done

grep -v "child" tmp.selection | sort -k1,1 > tmp.1
sort -k1,1 tmp.results | paste tmp.results tmp.1 > tmp.tmp
mv tmp.tmp Figure-Input-Data/Extended-Data-Figure-6f.REST-Silencer-Tissue-Enrichment.txt

rm tmp*
