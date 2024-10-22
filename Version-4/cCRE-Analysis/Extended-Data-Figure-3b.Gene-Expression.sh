#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Supplementary-Figure-6e

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

tsvDir=/data/projects/encode/data/

cd $workingDir
echo "" > tmp.matrix

tsvs=(ENCFF421TJX ENCFF863QWG ENCFF435PHM ENCFF721BRA)
for tsv in ${tsvs[@]}
do
    wget https://www.encodeproject.org/files/$tsv/@@download/$tsv.tsv
    awk 'BEGIN{print "gene" "\t" "'$tsv'"}{if (NR > 2) print $1 "\t" $6}' $tsv.tsv > tmp.col
    paste tmp.matrix tmp.col > tmp.tmp
    mv tmp.tmp tmp.matrix
done

awk '{printf "%s", $1; for(i=2;i<=NF;i+=2) printf "\t%s",$i ; print ""}' tmp.matrix > Gene-Expression-Matrix.K562-HepG2-HCT116-MCF7.txt

echo -e "Gene\tK562\tHepG2\tHCT116\tMCF-7" > tmp.list
genes=(ENSG00000102145 ENSG00000101076 ENSG00000141510 ENSG00000165702)
for gene in ${genes[@]}
do
    echo $gene
    grep $gene Gene-Expression-Matrix.K562-HepG2-HCT116-MCF7.txt >> tmp.list
done

mv tmp.list Figure-Input-Data/Extended-Data-Figure-3b.Gene-Expression.txt
rm tmp.* *.tsv

