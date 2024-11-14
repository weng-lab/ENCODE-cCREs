#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Supplementary-Figure-6e

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

soloQuant=Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
doubleQuant=Reddy-WG-STARR/ENCSR661FOW-DESeq2.Double-Pair.V7.txt

cd $workingDir

awk '{print $1 "\t" $3}' $soloQuant | ~/bin/randomLines -seed=6921 stdin 100000 tmp.1
awk '{print $1 "\t" $3}' $doubleQuant | ~/bin/randomLines -seed=6921 stdin 100000 tmp.2

awk '{print $0 "\t" "Solo"}' tmp.1 > Figure-Input-Data/Supplementary-Figure-6e.CAPRA-Fragment-Distributions.txt
awk '{print $0 "\t" "Double"}' tmp.2 >> Figure-Input-Data/Supplementary-Figure-6e.CAPRA-Fragment-Distributions.txt

rm tmp.*
