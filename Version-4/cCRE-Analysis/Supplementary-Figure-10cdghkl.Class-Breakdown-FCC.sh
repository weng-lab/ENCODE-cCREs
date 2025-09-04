#Jill Moore
#Moore Lab - UMass Chan
#August 2024

#Usage: ./Supplementary-Figure-5bdf.FCC-Positive-Overlap.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization/cCRE-Enrichment

ccreK562=K562-cCREs.bed

cd $workingDir

###MPRA
mpra=ENCFF677CJZ.bed
awk '{if ($7 > 1) print $0}' $mpra > tmp.positive
regions=tmp.positive

bedtools intersect -u -a $ccreK562 -b tmp.positive > tmp.yes
bedtools intersect -u -a $ccreK562 -b $mpra > tmp.1

python ~/bin/count.py tmp.yes 9 | sort -k1,1
python ~/bin/count.py tmp.1 9 | sort -k1,1

###STARR-seq
regions=ENCFF454ZKK.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig ENCFF454ZKK.bed out.tab
min=$(sort -k5,5g out.tab | head -n 1 | awk '{print $5}')

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' $ccreK562 > tmp.bed
~/bin/bigWigAverageOverBed ENCFF814CNR.bigWig tmp.bed tmp.out
awk '{if ($NF > '$min') print $0}' tmp.out | \
    awk 'FNR==NR {x[$1];next} ($4 in x)' - $ccreK562 | \
    bedtools intersect -f 0.5 -c -a stdin -b $regions > tmp.1

awk '{if ($NF > 0) print $0}' tmp.1 > tmp.yes

python ~/bin/count.py tmp.yes 9 | sort -k1,1
python ~/bin/count.py tmp.1 9 | sort -k1,1

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
    bedtools intersect -u -a stdin -b $regions > tmp.yes

bedtools intersect -u -a $ccreK562 -b tmp.guide > tmp.1

python ~/bin/count.py tmp.yes 9 | sort -k1,1
python ~/bin/count.py tmp.1 9 | sort -k1,1

#rm tmp.*
