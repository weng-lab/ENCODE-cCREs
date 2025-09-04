#Jill Moore
#Moore Lab - UMass Chan
#August 2024

#Usage: ./Supplementary-Figure-5bdf.FCC-Positive-Overlap.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization/cCRE-Enrichment

ccreK562=K562-cCREs.bed
ccreAll=tmp.all
background=Background.No-cCREs.bed

cd $workingDir

awk 'FNR==NR {x[$4];next} !($5 in x)' $ccreK562 ../../../hg38-cCREs-Unfiltered.bed > tmp.all
echo -e "Method" "\t" "Group" "\t" "Positive" "\t" "Tested" "\t" "Fraction" > tmp.output

###MPRA
mpra=ENCFF677CJZ.bed
awk '{if ($7 > 1) print $0}' $mpra > tmp.positive
regions=tmp.positive

bedtools intersect -u -a $ccreK562 -b $mpra | \
    bedtools intersect -c -a stdin -b $regions | \
    awk '{if ($NF > 0) sum +=1}END{print "MPRA" "\t" "k562-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output
bedtools intersect -v -a $mpra -b $ccreK562  > tmp.1
awk '{if ($7 > 1) print $0}' tmp.1 > tmp.positive

bedtools intersect -u -a $ccreAll -b tmp.1 | \
    bedtools intersect -c -a stdin -b $regions | \
    awk '{if ($NF > 0) sum +=1}END{print "MPRA" "\t" "all-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output
bedtools intersect -v -a tmp.1 -b $ccreK562  > tmp.2
awk '{if ($7 > 1) print $0}' tmp.2 > tmp.positive

bedtools intersect -u -a $background -b tmp.2 | \
    bedtools intersect -c -a stdin -b $regions | \
    awk '{if ($NF > 0) sum +=1}END{print "MPRA" "\t" "no-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output

###STARR-seq
regions=ENCFF454ZKK.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig ENCFF454ZKK.bed out.tab
min=$(sort -k5,5g out.tab | head -n 1 | awk '{print $5}')

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $ccreK562 > tmp.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig tmp.bed tmp.out
awk '{if ($NF > '$min') print $0}' tmp.out | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - tmp.bed | \
    bedtools intersect -c -a stdin -b $regions | \
    awk '{if ($NF > 0) sum +=1}END{print "STARR" "\t" "k562-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output
bedtools intersect -v -a $regions -b tmp.bed  > tmp.1

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $ccreAll > tmp.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig tmp.bed tmp.out
awk '{if ($NF > '$min') print $0}' tmp.out | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - tmp.bed | \
    bedtools intersect -c -a stdin -b tmp.1 | \
    awk '{if ($NF > 0) sum +=1}END{print "STARR" "\t" "all-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output
bedtools intersect -v -a tmp.1 -b tmp.bed  > tmp.2

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $background > tmp.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig tmp.bed tmp.out
awk '{if ($NF > '$min') print $0}' tmp.out | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - tmp.bed | \
    bedtools intersect -c -a stdin -b tmp.2 | \
    awk '{if ($NF > 0) sum +=1}END{print "STARR" "\t" "no-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output
        
###CRISPR
list=CRISPR-Sabeti.gRNA.txt
for i in `seq 1 1 9`
do
    exp=$(awk -F "\t" '{if (NR == '$i') print $1}' $list)
#    wget https://www.encodeproject.org/files/$exp/@@download/$exp.bed.gz
#    gunzip $exp.bed.gz
    cat $exp.bed | awk '{if ($1 ~ /chr/) print $0}' >> tmp.guide
done

regions=Reilly-Tewhey.41588_2021_900_MOESM3_ESM.Table-3.bed

bedtools intersect -u -a $ccreK562 -b tmp.guide | \
    bedtools intersect -c -a stdin -b $regions | \
    awk '{if ($NF > 0) sum +=1}END{print "CRISPR" "\t" "k562-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output
bedtools intersect -v -a $regions -b $ccreK562  > tmp.1

bedtools intersect -u -a $ccreAll -b tmp.guide | \
    bedtools intersect -c -a stdin -b tmp.1 | \
awk '{if ($NF > 0) sum +=1}END{print "CRISPR" "\t" "all-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output
bedtools intersect -v -a tmp.1 -b $ccreAll  > tmp.2

bedtools intersect -u -a $background -b tmp.guide | \
    bedtools intersect -c -a stdin -b tmp.2 | \
awk '{if ($NF > 0) sum +=1}END{print "CRISPR" "\t" "no-ccres" "\t" sum "\t" NR "\t" sum/NR}' >> tmp.output

mv tmp.output ../Figure-Input-Data/Supplementary-Figure-5bdf.FCC-cCRE-Activity.txt

rm tmp.*
