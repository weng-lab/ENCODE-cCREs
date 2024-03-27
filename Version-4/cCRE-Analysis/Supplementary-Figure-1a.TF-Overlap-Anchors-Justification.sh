#!/bin/bash
#SBATCH --nodes 1
#SBATCH --time=00:10:00
#SBATCH --mem=1G
#SBATCH --array=1-535
#SBATCH --output=/zata/zippy/moorej3/Job-Logs/jobid_%A_%a.output
#SBATCH --error=/zata/zippy/moorej3/Job-Logs/jobid_%A_%a.error
#SBATCH --partition=30mins

jid=$SLURM_ARRAY_TASK_ID
mkdir -p /tmp/moorej3/$SLURM_JOBID-$jid
cd /tmp/moorej3/$SLURM_JOBID-$jid

ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-rDHS/hg38-rDHS-Filtered.bed
tfList=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Input-Lists/Human.Sequence-Specific-TF-Experiments.txt
outputDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Anchor-TF-Overlap/

mkdir -p $outputDir

d1=$(awk '{if (NR == '$jid') print $1}' $tfList)
d2=$(awk '{if (NR == '$jid') print $2}' $tfList)
tf=$(awk -F "\t" '{if (NR == '$jid') print $4}' $tfList)
cell=$(awk -F "\t" '{if (NR == '$jid') print $3}' $tfList | awk '{gsub(/Homo sapiens /,"");print}' | awk '{gsub(/ /,"_");print}' )

cp /data/projects/encode/data/$d1/$d2.bed.gz bed.gz
gunzip bed.gz
awk '{print $1 "\t" $2 "\t" $2 "\t" "'$d1'" "\t" "'$cell'"}' bed > tmp.bed
rm bed

nPeaks=$(wc -l tmp.bed | awk '{print $1}')
bedtools intersect -c -a $ccres -b tmp.bed | awk 'BEGIN{sum=0}{if ($NF > 0) sum +=1}END{print sum "\t" sum/NR*100 "\t" "'$tf'" "\t" "'$d1'" "\t" "'$d2'" "\t" "'$cell'"}' > tmp.summary

mv tmp.summary $outputDir/$d1-Summary.txt

rm tmp.*
rm -r $SLURM_JOBID-$jid
