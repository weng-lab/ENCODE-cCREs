#!/bin/bash
#SBATCH --nodes 1
#SBATCH --time=00:30:00
#SBATCH --mem=5G
#SBATCH --array=1-706%100
#SBATCH --output=/home/moorej3/Job-Logs/jobid_%A_%a.output
#SBATCH --error=/home/moorej3/Job-Logs/jobid_%A_%a.error

#Step 1 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab
#May 2019

#TO RUN:
#sbatch 1_Process-DHSs.sh

genome=hg38
j=$SLURM_ARRAY_TASK_ID

dataDir=~/Lab/ENCODE/Encyclopedia/V5/$genome-DNase
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline
hotspots=$dataDir/$genome-Hotspot-List.txt

mkdir -p /tmp/moorej3/$SLURM_JOBID-$j
cd /tmp/moorej3/$SLURM_JOBID-$j


dset=$(cat $hotspots  | awk '{if (NR == '$j') print $1}')
dpeak=$(cat $hotspots  | awk '{if (NR == '$j') print $2}')
dsig=$(cat $hotspots  | awk '{if (NR == '$j') print $3}')

dhs=$dataDir/DHSs/$dpeak.DHSs.bed 
signal=/data/projects/encode/data/$dset/$dsig.bigWig

cp $dhs bed
awk '{print $1 "\t" $2 "\t" $3 "\t" "'$dpeak'-"NR "\t" $4}' bed | sort -k4,4 > new
awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' new > new.bed
~/bin/bigWigAverageOverBed $signal new.bed out.tab
python $scriptDir/calculate.zscore.sh out.tab | sort -k1,1 > 1
paste new 1 | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" \
    $8 "\t" "." "\t" $7 "\t" 1 "\t" $5}' > output.$dsig.$j

mkdir -p $dataDir/Processed-DHSs/
mv output.$dsig.$j $dataDir/Processed-DHSs/

rm -r /tmp/moorej3/$SLURM_JOBID-$j
