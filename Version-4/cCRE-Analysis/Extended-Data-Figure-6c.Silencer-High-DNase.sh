

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
cd $workingDir

ccres=../../hg38-cCREs-Unfiltered.bed
rm -f tmp.results
groups=(REST-Enhancers REST-Silencers STARR-Silencers.Stringent STARR-Silencers.Robust)
for group in ${groups[@]}
do
    total=$(wc -l $group.bed | awk '{print $1}')
    awk '{if ($2 > 1.64) print $1}' ../../signal-output/ENCSR000EOT-ENCFF414OGC.txt | \
        awk 'FNR==NR {x[$1];next} ($4 in x)' - $group.bed | wc -l | \
        awk '{print "'$group'" "\t" $1 "\t" '$total' "\t" $1/'$total'}' >> tmp.results
done

cat REST-Silencers.bed REST-Enhancers.bed STARR-Silencers.Robust.bed | sort -u > tmp.all
total=$(wc -l tmp.all | awk '{print $1}')
awk '{if ($2 > 1.64) print $1}' ../../signal-output/ENCSR000EOT-ENCFF414OGC.txt | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - tmp.all | wc -l | \
    awk '{print "All" "\t" $1 "\t" '$total' "\t" $1/'$total'}' >> tmp.results

mv tmp.results Figure-Input-Data/Extended-Data-Figure-5c.Silencer-High-DNase.txt
rm tmp*
