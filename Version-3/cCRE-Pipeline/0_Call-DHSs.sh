#!/bin/bash
#SBATCH --nodes 1
#SBATCH --time=12:00:00
#SBATCH --mem=10G
#SBATCH --array=1-202%100
#SBATCH --output=/home/moorej3/Job-Logs/jobid_%A_%a.output
#SBATCH --error=/home/moorej3/Job-Logs/jobid_%A_%a.error
#SBATCH --partition=12hours

genome=mm10
jid=$SLURM_ARRAY_TASK_ID

dataDir=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-$genome/$genome-rDHS
scriptDir=~/Projects/ENCODE/Encyclopedia/Version6/cCRE-Pipeline
hotspots=$dataDir/$genome-Hotspot-List.txt
#hotspots=$dataDir/ReRun-List.txt

bedtools=~/bin/bedtools2/bin/bedtools

minP=4942

mkdir -p /tmp/moorej3/$SLURM_JOBID-$jid
cd /tmp/moorej3/$SLURM_JOBID-$jid

exp=$(awk '{if (NR == '$jid') print $1}' $hotspots)
enrich=$(awk '{if (NR == '$jid') print $2}' $hotspots)

/bin/sleep   `/usr/bin/expr $RANDOM % 300`

if test -f "/data/projects/encode/data/$exp/$enrich.bed.gz"
then
    cp /data/projects/encode/data/$exp/$enrich.bed.gz $enrich.bed.gz
else
    wget https://www.encodeproject.org/files/$enrich/@@download/$enrich.bed.gz
fi

gunzip $enrich.bed.gz

echo "Step 1 ..." >> ~/Job-Logs/jobid_$SLURM_JOBID"_"$jid.error
cp $enrich.bed tmp.1
for j in `seq 2 1 $minP`
do
    cutoff=$(awk 'BEGIN{print "1E-'$j'"}')
    echo $cutoff >> ~/Job-Logs/jobid_$SLURM_JOBID"_"$jid.error
    python $scriptDir/filter-long-double.py tmp.1 $cutoff > tmp.2
    $bedtools merge -d 1 -c 5 -o min -i tmp.2 | \
        awk '{if ($3-$2 >= 50) print $0}' > $enrich.$cutoff.bed
    mv tmp.2 tmp.1
    num=$(wc -l $enrich.$cutoff.bed | awk '{print $1}')
    echo $cutoff $num
done

echo "Step 2 ..." >> ~/Job-Logs/jobid_$SLURM_JOBID"_"$jid.error
cutoff=1E-2
awk '{if ($3-$2 <= 350) print $0}' $enrich.$cutoff.bed > peaks
for j in `seq 3 1 $minP`
do
    echo -e "\t" $j >> ~/Job-Logs/jobid_$SLURM_JOBID"_"$jid.error
    cutoff=$(awk 'BEGIN{print "1E-'$j'"}')
    $bedtools intersect -v -a $enrich.$cutoff.bed -b peaks > tmp
    awk '{if ($3-$2 <= 350) print $0}' tmp >> peaks
done
mv peaks $enrich.DHSs.bed

$bedtools intersect -v -a $enrich.1E-$minP.bed -b $enrich.DHSs.bed > $enrich.Excluded.bed

mkdir -p $dataDir/DHSs
mv $enrich.Excluded.bed $enrich.DHSs.bed $dataDir/DHSs/

rm -r /tmp/moorej3/$SLURM_JOBID-$jid
