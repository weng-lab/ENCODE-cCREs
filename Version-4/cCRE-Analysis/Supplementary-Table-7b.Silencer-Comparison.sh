workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers

silencerDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/Published-Silencers/


cd $workingDir

silencers=(Jayavelu-Hawkins-2020/Candidate-Silencers.hg38.bed Pang-Snyder-2020/Called-Silencers.K562.hg38.bed Huan-Ovcharenko-2019/K562.hg38.bed Cai-Fullwood-2021/MRR.K562.hg38.bed)

rm -f tmp.matrix
touch tmp.matrix

for silencer1 in ${silencers[@]}
do
    echo $silencer1
    silencerRegion1=$silencerDir/$silencer1
    echo $silencer1 > tmp.col
    for silencer2 in ${silencers[@]}
    do
	echo $silencer2
        silencerRegion2=$silencerDir/$silencer2
	bedtools intersect -c -a $silencerRegion1 -b $silencerRegion2 | awk '{if ($NF > 0) sum += 1}END{print sum/NR}' >> tmp.col
    done
    paste tmp.matrix tmp.col > tmp.tmp
    mv tmp.tmp tmp.matrix
done


mv tmp.matrix Table-Input-Data/Supplementary-Table-7b.Silencer-Overlap.txt
rm tmp.*
