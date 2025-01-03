

ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
motifs=~/GitHub/ENCODE-cCREs/Version-4/Supplementary-Data/Supplementary-Data-X.Factorbook-REST-Motif-Sites.txt
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
cd $workingDir

grep REST ../../hg38-TF/hg38-TF-List.Filtered.txt > tmp.list

list=tmp.list
k=$(wc -l $list | awk '{print $1}')
rm -f tmp.bed
for j in `seq 1 1 $k`
do
    echo $j
    d1=$(awk '{if (NR == '$j') print $1}' $list)
    d2=$(awk '{if (NR == '$j') print $2}' $list)
    cp /data/projects/encode/data/$d1/$d2.bed.gz bed.gz
    gunzip bed.gz
    awk '{print $1 "\t" $2+$10-1 "\t" $2+$10}' bed >> tmp.bed
    rm bed
done

bedtools intersect -c -a $ccres -b tmp.bed | awk '{if ($NF > 5) print $0}' | \
    bedtools intersect -u -a stdin -b $motifs | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' > REST-cCREs.All.bed

grep -v PLS REST-cCREs.All.bed > REST-cCREs.noPLS.bed
