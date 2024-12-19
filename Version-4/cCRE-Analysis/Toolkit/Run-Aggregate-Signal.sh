#!/bin/bash
#Jill E. Moore
#Weng Lab
#UMass Medical School
#Updated March 2020

mode=$1
workingDir=$2
bigWig=$3
ccres=$4
scriptDir=~/Projects/ENCODE/Encyclopedia/Version7/cCRE-Analysis
echo $ccres

##Step 1 - Run first batch###
num=$(wc -l $ccres | awk '{print int($1/100)}')
if [ $num -gt 0 ]
then
jobid=$(sbatch --nodes 1 --array=1-$num%50 --mem=10G --time=00:30:00 \
    --output=/zata/zippy/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/zata/zippy/moorej3/Job-Logs/jobid_%A_%a.error \
    $scriptDir/Aggregate-Signal-Batch-1.sh $mode $ccres $workingDir $bigWig | awk '{print $4}')
echo $jobid
sleep 20
list=100
while [ $list -gt 1 ]
do
    list=$(squeue -j $jobid | wc -l | awk '{print $1}')
    sleep 10
done
fi

cd $workingDir/Output/$mode/

for f in agg-output.*;
do
echo $f
cat final.res | paste - $f | awk '{print $1+$3 "\t" $2+$4}' > tmp; cp tmp final.res
done
awk 'BEGIN{print "'$mode'"}{print $2/$1}' final.res > $mode.summary

rm final.res
