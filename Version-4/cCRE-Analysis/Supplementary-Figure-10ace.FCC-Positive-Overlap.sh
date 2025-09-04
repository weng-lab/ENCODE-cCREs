#Jill Moore
#Moore Lab - UMass Chan
#August 2024

#Usage: ./Supplementary-Figure-5ace.FCC-Positive-Overlap.sh


workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization/cCRE-Enrichment
ccreAll=../../../hg38-cCREs-Unfiltered.bed
ccreK562=K562-cCREs.bed

cd $workingDir

echo -e "Method" "\t" "K562-cCRE" "\t" "All-cCRE" "\t" "No-cCRE" > tmp.out

###MPRA
mpra=ENCFF677CJZ.bed
awk '{if ($7 > 1) print $0}' $mpra > tmp.positive
regions=tmp.positive

k562Total=$(bedtools intersect -u -a $regions -b $ccreK562 | wc -l | awk '{print $1}')
ccreTotal=$(bedtools intersect -u -a $regions -b $ccreAll | wc -l | awk '{print $1}')
none=$(bedtools intersect -v -a $regions -b $ccreAll | wc -l | awk '{print $1}')

awk 'BEGIN{print "MPRA" "\t" '$k562Total' "\t" '$ccreTotal'-'$k562Total' "\t" '$none'}' >> tmp.out

###STARR-seq
regions=ENCFF454ZKK.bed

k562Total=$(bedtools intersect -u -a $regions -b $ccreK562 | wc -l | awk '{print $1}')
ccreTotal=$(bedtools intersect -u -a $regions -b $ccreAll | wc -l | awk '{print $1}')
none=$(bedtools intersect -v -a $regions -b $ccreAll | wc -l | awk '{print $1}')

awk 'BEGIN{print "STARR" "\t" '$k562Total' "\t" '$ccreTotal'-'$k562Total' "\t" '$none'}' >> tmp.out

###CRISPR
regions=Reilly-Tewhey.41588_2021_900_MOESM3_ESM.Table-3.bed

k562Total=$(bedtools intersect -u -a $regions -b $ccreK562 | wc -l | awk '{print $1}')
ccreTotal=$(bedtools intersect -u -a $regions -b $ccreAll | wc -l | awk '{print $1}')
none=$(bedtools intersect -v -a $regions -b $ccreAll | wc -l | awk '{print $1}')

awk 'BEGIN{print "CRISPR" "\t" '$k562Total' "\t" '$ccreTotal'-'$k562Total' "\t" '$none'}' >> tmp.out

mv tmp.out ../Figure-Input-Data/Supplementary-Figure-5ace.FCC-Positive-Overlap.txt


