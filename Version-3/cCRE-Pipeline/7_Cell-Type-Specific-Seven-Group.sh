
genome=$1
scriptDir=~/Projects/ENCODE/Encyclopedia/Version6/cCRE-Pipeline

cd ~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-$genome
python $scriptDir/match-biosamples.py > Cell-Type-Specific/Master-Cell-List.txt
cp ~/Lab/Reference/cres.as Cell-Type-Specific/

files=~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-$genome/Cell-Type-Specific/Master-Cell-List.txt
num=$(wc -l $files | awk '{print $1}')

mkdir -p ~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-$genome/Cell-Type-Specific/Seven-Group
#mkdir -p ~/Lab/ENCODE/Encyclopedia/V6/Registry/V6-$genome/Cell-Type-Specific/Nine-State

for j in `seq 1 1 $num`
do
    DNase=$(awk '{if (NR == '$j') print $1}' $files)
    echo $DNase
    if [[ $DNase != "---" ]]
    then
        sbatch --nodes 1 --mem=1G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A.output \
            --error=/home/moorej3/Job-Logs/jobid_%A.error \
            $scriptDir/Split-cCREs.DNase.sh $files $j $genome
    else
        sbatch --nodes 1 --mem=1G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A.output \
            --error=/home/moorej3/Job-Logs/jobid_%A.error \
            $scriptDir/Split-cCREs.No-DNase.sh $files $j $genome
    fi
    /bin/sleep 1
done


