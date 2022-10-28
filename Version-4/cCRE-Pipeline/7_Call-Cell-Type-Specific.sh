
genome=$1
scriptDir=~/Projects/ENCODE/Encyclopedia/Version7/cCRE-Pipeline
tfList=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/$genome-TF/$genome-TF-List.Filtered-Mod.txt

cd ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome
mkdir -p Cell-Type-Specific
python $scriptDir/match-biosamples.py > tmp
awk -F "\t" 'FNR==NR {x[$NF];next} ($9 in x)' $tfList tmp | awk '{print $0 "\t" "yes"}' > Cell-Type-Specific/Master-Cell-List.txt
awk -F "\t" 'FNR==NR {x[$NF];next} !($9 in x)' $tfList tmp | awk '{print $0 "\t" "no"}' >> Cell-Type-Specific/Master-Cell-List.txt
cp ~/Lab/Reference/cres.as Cell-Type-Specific/
cp ~/Lab/Reference/blank.txt signal-output/

files=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/Cell-Type-Specific/Master-Cell-List.txt
num=$(wc -l $files | awk '{print $1}')
output=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/Cell-Type-Specific/Individual-Files
mkdir -p ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-$genome/Cell-Type-Specific/Individual-Files

#num=230
for j in `seq 1 1 $num`
do
    DNase=$(awk '{if (NR == '$j') print $1}' $files)
    TF=$(awk '{if (NR == '$j') print $NF}' $files)
    echo $DNase
    if [[ $DNase != "---" && $TF == "yes" ]]
    then
        echo "TF"
        sbatch --nodes 1 --mem=5G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A.output \
            --error=/home/moorej3/Job-Logs/jobid_%A.error \
            $scriptDir/Split-cCREs.TF.sh $files $j $genome $output

    elif [[ $DNase != "---" ]]
    then
        sbatch --nodes 1 --mem=1G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A.output \
            --error=/home/moorej3/Job-Logs/jobid_%A.error \
            $scriptDir/Split-cCREs.DNase.sh $files $j $genome $output
    else
        sbatch --nodes 1 --mem=1G --time=00:30:00 \
            --output=/home/moorej3/Job-Logs/jobid_%A.output \
            --error=/home/moorej3/Job-Logs/jobid_%A.error \
            $scriptDir/Split-cCREs.No-DNase.sh $files $j $genome $output
    fi
    /bin/sleep 1
done


