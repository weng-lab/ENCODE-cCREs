#date=$(date +%m-%d-%Y)
#list=HiC-List.$date.txt
list=HiC-List.Clean.txt

dataDir=/data/projects/encode/data/
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/Encyclopedia-Overlap/Hi-C
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir
#python pull-HiC.py > $list

k=$(wc -l $list | awk '{print $1}')
for j in `seq 1 1 $k`
do
    echo $j
    exp=$(awk '{if (NR == '$j') print $1}' $list)
    bed=$(awk '{if (NR == '$j') print $2}' $list)
    bio=$(awk -F "\t" '{if (NR == '$j') print $3}' $list | awk '{gsub(/ /,"_");print}')

    if test -f "/data/projects/encode/data/$exp/$bed.bedpe.gz"
    then
        cp /data/projects/encode/data/$exp/$bed.bedpe.gz bedpe.gz
    else
        wget https://www.encodeproject.org/files/$bed/@@download/$bed.bedpe.gz
        mv $bed.bedpe.gz bedpe.gz
    fi
    gunzip bedpe.gz
    awk '{if ($1 == $4) print $1 "\t" $2 "\t" $3 "\t" "Link-"NR "\t" $4 "\t" $5 "\t" $6}' bedpe > tmp.1
    awk '{if ($1 == $4) print $4 "\t" $5 "\t" $6 "\t" "Link-"NR "\t" $1 "\t" $2 "\t" $3}' bedpe >> tmp.1

    grep EH38E3291318 $ccres | bedtools intersect -wo -a stdin -b tmp.1 | awk '{print $0 "\t" "'$exp'" "\t" "'$bed'" "\t" "'$bio'"}' >> tmp.1-intersect
    rm bedpe
done

mv tmp.1-intersect ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/4_Use-Case/Table-Input-Data/Supplementary-Table-12f.HiC-Loop-Overlap-EH38E3291318.txt

rm -f tmp*
