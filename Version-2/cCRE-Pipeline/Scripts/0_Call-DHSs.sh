#!/bin/bash
#SBATCH --nodes 1
#SBATCH --time=12:00:00
#SBATCH --mem=10G
#SBATCH --array=1-706%100
#SBATCH --output=/home/moorej3/Job-Logs/jobid_%A_%a.output
#SBATCH --error=/home/moorej3/Job-Logs/jobid_%A_%a.error
#SBATCH --partition=12hours

#Step 0 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab
#November 2019

#TO RUN:
#sbatch 0_Call-DHSs.sh

genome=hg38
jid=$SLURM_ARRAY_TASK_ID

dataDir=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline
hotspots=$dataDir/$genome-Hotspot-List.txt

bedtools=~/bin/bedtools2/bin/bedtools

minP=4942

mkdir -p /tmp/moorej3/$SLURM_JOBID-$jid
cd /tmp/moorej3/$SLURM_JOBID-$jid

exp=$(awk '{if (NR == '$jid') print $1}' $hotspots)
enrich=$(awk '{if (NR == '$jid') print $2}' $hotspots)

/bin/sleep   `/usr/bin/expr $RANDOM % 300`

cp /data/projects/encode/data/$exp/$enrich.bed.gz $enrich.bed.gz
gunzip $enrich.bed.gz

#~/bin/bedops/unstarch $enrich > $enrich.bed

echo "Step 1 ..." >> ~/Job-Logs/jobid_$SLURM_JOBID"_"$jid.error
cp $enrich.bed 1
for j in `seq 2 1 $minP`
do
    cutoff=$(awk 'BEGIN{print "1E-'$j'"}')
    echo $cutoff >> ~/Job-Logs/jobid_$SLURM_JOBID"_"$jid.error
    python $scriptDir/filter.long.double.py 1 $cutoff > 2
    $bedtools merge -d 1 -c 5 -o min -i 2 | \
        awk '{if ($3-$2 >= 50) print $0}' > $enrich.$cutoff.bed
    mv 2 1
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
#mv * $dataDir/Processed-DHSs/

rm -r /tmp/moorej3/$SLURM_JOBID-$jid
