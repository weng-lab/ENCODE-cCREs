#!/bin/bash
#SBATCH --nodes 1
#SBATCH --time=00:30:00
#SBATCH --mem=5G
#SBATCH --array=1-202%100
#SBATCH --output=/home/moorej3/Job-Logs/jobid_%A_%a.output
#SBATCH --error=/home/moorej3/Job-Logs/jobid_%A_%a.error

genome=mm10
j=$SLURM_ARRAY_TASK_ID

dataDir=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-$genome/$genome-rDHS
scriptDir=~/Projects/ENCODE/Encyclopedia/Version6/cCRE-Pipeline
hotspots=$dataDir/$genome-Hotspot-List.txt

mkdir -p /tmp/moorej3/$SLURM_JOBID-$j
cd /tmp/moorej3/$SLURM_JOBID-$j

dset=$(cat $hotspots  | awk '{if (NR == '$j') print $1}')
dpeak=$(cat $hotspots  | awk '{if (NR == '$j') print $2}')
dsig=$(cat $hotspots  | awk '{if (NR == '$j') print $3}')

dhs=$dataDir/DHSs/$dpeak.DHSs.bed 
signal=/data/projects/encode/data/$dset/$dsig.bigWig

/bin/sleep   `/usr/bin/expr $RANDOM % 120`

cp $dhs bed
awk '{print $1 "\t" $2 "\t" $3 "\t" "'$dpeak'-"NR "\t" $4}' bed | sort -k4,4 > new
awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' new > new.bed
~/bin/bigWigAverageOverBed $signal new.bed out.tab
sort -k1,1 out.tab > tmp.1
paste new tmp.1 | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $10}' >  output.$dsig.$j

mkdir -p $dataDir/Processed-DHSs/
mv output.$dsig.$j $dataDir/Processed-DHSs/

rm -r /tmp/moorej3/$SLURM_JOBID-$j
