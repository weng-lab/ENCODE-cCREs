


source ~/.bashrc


workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
rdhs=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-rDHS/hg38-rDHS-Filtered.bed


cd $workingDir

groups=(H3K27ac H3K4me3 H3K4me1)
for group in ${groups[@]}
do
    echo $group
    python $scriptDir/pull-histone-peaks.py hg38 $group > tmp.$group

    rm -r tmp.results
    total=$(wc -l tmp.$group | awk '{print $1}')
    for i in `seq 1 1 $total`
    do
        echo $i
        exp=$(awk -F "\t" '{if (NR == '$i') print $1}' tmp.$group)
        peak=$(awk -F "\t" '{if (NR == '$i') print $2}' tmp.$group)

        file=/data/projects/encode/data/$exp/$peak.bed.gz
        if [ -f "$file" ]
        then
            cp /data/projects/encode/data/$exp/$peak.bed.gz bed.gz
            else
            wget https://www.encodeproject.org/files/$bed/@@download/$bed.bed.gz
            mv $bed.bed.gz bed.gz
        fi
        gunzip bed.gz
        bedtools intersect -c -a bed -b $rdhs | \
            awk 'BEGIN{sum=0}{if ($NF > 0) sum +=1}\
            END{print "'$exp'" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.results
            rm bed
    done
    awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.results tmp.$group | \
        paste - tmp.results > Table-Input-Data/Supplementary-Table-2.$group-Peak-Overlap.txt
done
