
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
cd $workingDir

publishedTested=Published-Silencers/Jayavelu-Hawkins-2020/Tested-Regions.hg38.bed
publishedActive=Published-Silencers/Jayavelu-Hawkins-2020/Positive-Regions.hg38.bed

rm -f tmp.results
groups=(REST-Enhancers REST-Silencers STARR-Silencers.Stringent STARR-Silencers.Robust)
for group in ${groups[@]}
do
    total=$(wc -l $group.bed | awk '{print $1}')
    bedtools intersect -u -a $group.bed -b $publishedTested | \
        bedtools intersect -c -a stdin -b $publishedActive | \
        awk '{if ($NF > 0) sum += 1}END{print "'$group'" "\t" \
        sum "\t" NR "\t" '$total' "\t" sum/NR "\t" NR/'$total'}' >> tmp.results

done

cat REST-Silencers.bed REST-Enhancers.bed STARR-Silencers.Robust.bed | sort -u > tmp.all
total=$(wc -l tmp.all | awk '{print $1}')
bedtools intersect -u -a tmp.all -b $publishedTested | \
    bedtools intersect -c -a stdin -b $publishedActive | \
    awk '{if ($NF > 0) sum += 1}END{print "All" "\t" \
    sum "\t" NR "\t" '$total' "\t" sum/NR "\t" NR/'$total'}' >> tmp.results


mv tmp.results Figure-Input-Data/Extended-Data-Figure-5ab.Previous-Silencer-Comparison.txt
rm tmp*
