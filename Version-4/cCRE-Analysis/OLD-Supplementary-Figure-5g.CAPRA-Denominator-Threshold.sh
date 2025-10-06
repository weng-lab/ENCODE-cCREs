#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Supplementary-Figure-5g.CAPRA-Denominator-Threshold.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

soloMatrix=Reddy-WG-STARR/ENCSR661FOW-Matrix.Solo-Filtered.V7.txt

cd $workingDir

for i in `seq 1 1 30`
do
    awk '{if ($2 > '$i' && NR > 1) sum += 1}END{print '$i' "\t" sum}' $soloMatrix >> \
        Figure-Input-Data/Supplementary-Figure-5g.CAPRA-Denominator-Threshold.txt
done


