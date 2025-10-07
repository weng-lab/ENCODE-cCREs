#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 18e

source ~/.bashrc

scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers

rest1=REST-Enhancers.bed
rest2=REST-Silencers.bed
starr1=STARR-Silencers.Stringent.bed
starr2=STARR-Silencers.Robust.bed
cf=Published-Silencers/Cai-Fullwood-2021/Positive-cCREs.bed
ho=Published-Silencers/Huan-Ovcharenko-2019/Positive-cCREs.bed
jh=Published-Silencers/Jayavelu-Hawkins-2020/Positive-cCREs.bed
ps=Published-Silencers/Pang-Snyder-2020/Positive-cCREs.bed
ke=K562-dELS.bed
ki=K562-Inactive.bed
kp=K562-PLS.bed

cd $workingDir

chromhmm=ENCFF106BGJ.bed

echo -e "state\tREST+enhancer\tREST+enhancer\tREST+enhancer\tREST+silencer\tREST+silencer\tREST+silencer\tSTARR-stringent\tSTARR-stringent\tSTARR-stringent\tSTARR-robust\tSTARR-robust\tSTARR-robust\tCao\tCao\tCao\tHuan\tHuan\tHuan\tJayavelu\tJayavelu\tJayavelu\tPang\tPang\tPang\tK562-Enhancer\tK562-Enhancer\tK562-Enhancer\tK562-Inactive\tK562-Inactive\tK562-Inactive\tK562-Promoter\tK562-Promoter\tK562-Promoter" > tmp.results

echo -e "state\tREST+enhancer\tREST+silencer\tSTARR-stringent\tSTARR-robust\tCao\tHuan\tJayavelu\tPang\tK562-Enhancer\tK562-Inactive\tK562-Promoter" >tmp.matrix

states=$(awk '{print $4}' ENCFF106BGJ.bed | sort -u)
for state in ${states[@]}
do
    echo $state

    awk '{if ($4 == "'$state'") print $0}' $chromhmm > tmp.state

R1=$(bedtools intersect -c -a $rest1 -b tmp.state | 
     awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
R2=$(bedtools intersect -c -a $rest2 -b tmp.state | 
     awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
S1=$(bedtools intersect -c -a $starr1 -b tmp.state | 
     awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
S2=$(bedtools intersect -c -a $starr2 -b tmp.state | 
     awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
CF=$(bedtools intersect -c -a $cf -b tmp.state | 
    awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
HO=$(bedtools intersect -c -a $ho -b tmp.state | 
    awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
JH=$(bedtools intersect -c -a $jh -b tmp.state | 
    awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
PS=$(bedtools intersect -c -a $ps -b tmp.state | 
    awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
KE=$(bedtools intersect -c -a $ke -b tmp.state | 
    awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
KI=$(bedtools intersect -c -a $ki -b tmp.state |
    awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')
KP=$(bedtools intersect -c -a $kp -b tmp.state |
    awk 'BEGIN{sum=0}{if ($NF > 0) sum += 1}END{print sum "\t" NR "\t" sum/NR}')

echo -e $state "\t" $R1 "\t" $R2 "\t" $S1 "\t" $S2 "\t" $CF "\t" $HO "\t" $JH "\t" $PS "\t" $KE "\t" $KI "\t" $KP |
    awk '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf "\t%s",$i ; print ""}'  >> tmp.results
echo -e $state "\t" $R1 "\t" $R2 "\t" $S1 "\t" $S2 "\t" $CF "\t" $HO "\t" $JH "\t" $PS "\t" $KE "\t" $KI "\t" $KP |
    awk '{printf "%s", $1; for(i=4;i<=NF;i+=3) printf "\t%s",$i ; print ""}'  >> tmp.matrix

done
mv tmp.results Table-Input-Data/Supplementary-Table-12c.Silencer-ChromHMM-Overlap.txt
mv tmp.matrix Figure-Input-Data/Supplementary-Figure-18e.ChromHMM-Overlap-Heatmap.txt

rm tmp.*
