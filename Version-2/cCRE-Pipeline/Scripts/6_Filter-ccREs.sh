
genome=$1
scriptDir=~/Projects/ENCODE/Encyclopedia/Version5/ccRE-Pipeline
dir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome/Cell-Type-Specific


mkdir -p $dir
rm -f $dir/Concordant-Analysis/*


cd ~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-$genome
python $scriptDir/match.biosamples.py > Cell-Type-Specific/Master-Cell-List.txt
list=$dir/Master-Cell-List.txt

num=$(wc -l $list | awk '{print $1}')
jobid=$(sbatch --nodes 1 --array=1-$num%20 --mem=10G --time=04:00:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    $scriptDir/ExtractConcordant.sh $genome | awk '{print $4}')

echo $jobid

sleep 20
list=100
while [ $list -gt 1 ]
do
list=$(squeue -j $jobid | wc -l | awk '{print $1}')
echo -e "jobs still running: $list"
sleep 10
done

sbatch --nodes 1 --mem=10G --time=04:00:00 \
    --output=/home/moorej3/Job-Logs/jobid_%A_%a.output \
    --error=/home/moorej3/Job-Logs/jobid_%A_%a.error \
    $scriptDir/ExtractClass.sh $dir $genome

