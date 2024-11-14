#list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization/MPRA-Agnostic-List.txt
list=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/MPRA-Unique.Released.04-22-2023.txt
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
dataDir=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data
background=cCRE-Enrichment/Background.No-cCREs.bed
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization

cd $workingDir

k=$(wc -l $list | awk '{print $1}')

for i in `seq 1 1 $k`
do
    exp=$(awk -F "\t" '{if (NR == "'$i'") print $1}' $list)
    bed=$(awk -F "\t" '{if (NR == "'$i'") print $5}' $list)
    genome=$(awk -F "\t" '{if (NR == "'$i'") print $6}' $list)
    cell=$(awk -F "\t" '{if (NR == "'$i'") print $3}' $list)
    dnase=$(grep $cell"_ENCD" ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Master-Cell-List.txt | awk '{print $2}')

    #if [ -f $dataDir/$exp/$bed.bed.gz ]
    #then
    #    gunzip $dataDir/$exp/$bed.bed.gz
    #fi
    total=$(wc -l $dataDir/$exp/$bed.bed | awk '{print $1}')
    awk '{if ($7 >= 1) print $0}' $dataDir/$exp/$bed.bed > pos.bed
    pos=$(wc -l pos.bed | awk '{print $1}')
    max=$(awk '{print $3-$2}' $dataDir/$exp/$bed.bed | sort -k1,1rg | head -n 1 | awk '{print $1}')
    min=$(awk '{print $3-$2}' $dataDir/$exp/$bed.bed | sort -k1,1g | head -n 1 | awk '{print $1}')
    
    if [ $genome == "hg19" ]
    then
         awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $dataDir/$exp/$bed.bed | ~/bin/liftOver stdin ~/Lab/Reference/Human/hg19/hg19ToHg38.over.chain tmp.all no
         awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' pos.bed | ~/bin/liftOver stdin ~/Lab/Reference/Human/hg19/hg19ToHg38.over.chain tmp.pos no
    else
        cp pos.bed tmp.pos
        cp $dataDir/$exp/$bed.bed tmp.all
    fi
    totalA=$(bedtools intersect -f 1 -u -b $ccres -a tmp.all | wc -l | awk '{print $1}')
    totalAP=$(bedtools intersect -f 1 -v -b $ccres -a tmp.all | bedtools intersect -u -a stdin -b $ccres | wc -l | awk '{print $1}')
    totalB=$(bedtools intersect -v -b $ccres -a tmp.all | wc -l | awk '{print $1}')
    posA=$(bedtools intersect -f 1 -u -b $ccres -a tmp.pos | wc -l | awk '{print $1}')
    posAP=$(bedtools intersect -f 1 -v -b $ccres -a tmp.pos | bedtools intersect -u -a stdin -b $ccres | wc -l | awk '{print $1}')
    posB=$(bedtools intersect -v -b $ccres -a tmp.pos | wc -l | awk '{print $1}')

    totalCell=$(grep -v "Low-DNase" ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/$dnase*.bed | bedtools intersect -f 1 -u -b stdin -a tmp.all | wc -l | awk '{print $1}')
    totalOther=$(grep "Low-DNase" ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/$dnase*.bed | bedtools intersect -f 1 -u -b stdin -a tmp.all | wc -l | awk '{print $1}')
    posCell=$(grep -v "Low-DNase" ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/$dnase*.bed | bedtools intersect -f 1 -u -b stdin -a tmp.pos | wc -l | awk '{print $1}')
    posOther=$(grep "Low-DNase" ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/$dnase*.bed | bedtools intersect -f 1 -u -b stdin -a tmp.pos | wc -l | awk '{print $1}')

    echo -e $exp "\t" $bed "\t" $min "\t" $max "\t" $total "\t" $pos "\t" $bed "\t" $totalA "\t" $totalAP "\t" $totalB "\t" $posA "\t" $posAP "\t" $posB "\t" $totalCell "\t" $totalOther "\t" $posCell "\t" $posOther
    
done
