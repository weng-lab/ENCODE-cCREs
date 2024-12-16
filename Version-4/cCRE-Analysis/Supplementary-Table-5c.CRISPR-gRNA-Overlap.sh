workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
cd $workingDir

ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.b

dataDir=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data
crisprList=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/CRISPR-List.12-06-24.txt
grep -v "Missing" $crisprList | awk -F "\t" '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $(NF-1) "\t" $NF }'  | \
    grep -v "Yin Shen"  > tmp.exp
rm -f tmp.tsv tmp.summary
k=$(wc -l tmp.exp | awk '{print $1}')
for i in `seq 1 1 $k`
do
    exp=$(awk -F "\t" '{if (NR == "'$i'") print $1}' tmp.exp)
    genome=$(awk -F "\t" '{if (NR == "'$i'") print $5}' tmp.exp)
    grep $exp $crisprList > tmp.sub
    echo $i  $exp
    rm -f tmp.tsv

    l=$(wc -l tmp.sub | awk '{print $1}')
    for j in `seq 1 1 $l`
    do
        tsv=$(awk -F "\t" '{if (NR == "'$j'") print $9}' tmp.sub)
        awk '{if ($1 ~ /chr/) print $1 "\t" $2 "\t" $3}' $dataDir/$exp/$tsv.tsv >> tmp.tsv
    done
    sort -u tmp.tsv > tmp.tmp
    if [ $genome == "hg19" ]
    then
        ~/bin/liftOver tmp.tmp ~/Lab/Reference/Human/hg19/hg19ToHg38.over.chain tmp.tsv no
    else
        mv tmp.tmp tmp.tsv
    fi
    numcCRE=$(bedtools intersect -c -b tmp.tsv -a $ccres | awk '{if ($NF > 0) sum +=1}END{print sum}') 
    bedtools intersect -c -a tmp.tsv -b $ccres | awk '{if ($NF > 0) sum +=1}END{print "'$exp'" "\t" sum "\t" NR "\t" sum/NR "\t" "'$numcCRE'"}' >> tmp.summary
done 

mv tmp.summary Table-Input-Data/Supplementary-Table-5c.CRISPR-gRNA-Overlap-Summary.txt

