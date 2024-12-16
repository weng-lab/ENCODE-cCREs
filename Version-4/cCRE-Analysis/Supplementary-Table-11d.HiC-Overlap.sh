date=$(date +%m-%d-%Y)
list=HiC-List.$date.txt

#python pull-HiC.py > $list

dataDir=/data/projects/encode/data/
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/Encyclopedia-Overlap/Hi-C
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

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
    gunzip bedpe
    awk '{if ($1 == $4) print $1 "\t" $2 "\t" $3 "\t" "Link-"NR}' bedpe > tmp.1
    awk '{if ($1 == $4) print $4 "\t" $5 "\t" $6 "\t" "Link-"NR}' bedpe > tmp.2

    bedtools intersect -u -b $ccres -a tmp.1 > tmp.1-intersect
    bedtools intersect -u -b $ccres -a tmp.2 > tmp.2-intersect
    total=$(wc -l tmp.1 | awk '{print $1}')
    one=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    both=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    awk 'BEGIN {print "'$bio'" "\t" '$total' "\t" '$one' "\t" '$one'/'$total' "\t" '$both' "\t" '$both'/'$total'}' >> tmp.results
    rm bedpe
done

mv tmp.results ../Table-Input-Data/Supplementary-Table-X.Overlap-HiC-Loops.txt
