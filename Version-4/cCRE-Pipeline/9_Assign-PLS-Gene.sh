

regions=$1
idColumn=$2
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Pipeline/Toolkit/

if [[ $genome == "mm10" ]]
then
    prox=~/Lab/Reference/Mouse/GENCODEM25/TSS.Basic.4K.bed
    tss=~/Lab/Reference/Mouse/GENCODEM25/TSS.Basic.bed
elif [[ $genome == "hg38" ]]
then
    prox=~/Lab/Reference/Human/$genome/GENCODE40/TSS.Basic.4K.bed
    tss=~/Lab/Reference/Human/$genome/GENCODE40/TSS.Basic.bed
fi

bedtools intersect -wo -a $regions -b $tss > tmp.tss
bedtools intersect -v -a $regions -b $tss > tmp.no

bedtools intersect -u -a tmp.no -b $prox | bedtools closest -d -a stdin -b $tss > tmp.distance
python $scriptDir/calculate-center-distance.py tmp.distance assignment > tmp.new
awk '{print $5 "\t" $13}' tmp.tss | cat - tmp.new | sort -u > tmp.assignment
