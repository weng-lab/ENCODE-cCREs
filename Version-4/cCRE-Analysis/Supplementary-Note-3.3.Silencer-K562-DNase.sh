scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
dnase=../../signal-output/ENCSR000EOT-ENCFF414OGC.txt
cd $workingDir

silencers=Silencer-cCREs.bed

awk 'FNR==NR {x[$4];next} ($1 in x)' $silencers $dnase | awk '{print $1 "\t" $2 "\t" "silencer"}' > tmp.results
awk 'FNR==NR {x[$4];next} !($1 in x)' $silencers $dnase > tmp.tmp
~/bin/randomLines tmp.tmp 100000 tmp.out
awk '{print $1 "\t" $2 "\t" "background"}' tmp.out >> tmp.results
Rscript $scriptDir/silencer-comparison-starr.R

rm tmp.*
