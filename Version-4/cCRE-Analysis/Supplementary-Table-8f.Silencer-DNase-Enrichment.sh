
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
cd $workingDir

group=Silencer-cCREs.bed
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
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

awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' tmp.results > Table-Input-Data/Supplementary-Table-8f.Silencer-DNase-Enrichment.txt


