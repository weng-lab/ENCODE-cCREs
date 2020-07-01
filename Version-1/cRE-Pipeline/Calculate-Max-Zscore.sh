source ~/.bashrc

dataList=$1
signalDir=$2
dataType=$3
genome=$4

python /home/jm36w/scratch/Test/calculate-max-zscore.py $dataList $signalDir > $genome-$dataType-MaxZ

