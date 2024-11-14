#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Extended-Data-Figure-3a.STARR-Cross-Cell.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

grep dELS $ccres > tmp.ccres

stars=(ENCSR858MPS ENCSR135NXN)
star=ENCSR858MPS
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $1 "\t" $3}' > tmp.col
star=ENCSR135NXN
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.ccres White-WG-STARR/$star-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $3}' | paste tmp.col - > tmp.matrix

awk '{if ($2 > 0 && $2 > $3+1) print $0}' tmp.matrix > tmp.K562
awk '{if ($3 > 0 && $3 > $2+1) print $0}' tmp.matrix > tmp.HepG2

rm -f tmp.matrix
touch tmp.matrix
tsvs=(ENCFF421TJX ENCFF863QWG ENCFF435PHM ENCFF721BRA)
for tsv in ${tsvs[@]}
do
    #wget https://www.encodeproject.org/files/$tsv/@@download/$tsv.tsv
    awk 'BEGIN{print "gene" "\t" "'$tsv'"}{if (NR > 2) print $1 "\t" $6}' $tsv.tsv > tmp.col
    paste tmp.matrix tmp.col > tmp.tmp
    mv tmp.tmp tmp.matrix
done

awk '{printf "%s", $1; for(i=2;i<=NF;i+=2) printf "\t%s",$i ; print ""}' tmp.matrix > Gene-Expression-Matrix.K562-HepG2-HCT116-MCF7.txt

rm -f tmp.tf
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/HOCOMOCO-List.txt
motifDir=/data/zusers/moorej3/moorej.ghpcc.project/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs/
for i in `seq 1 1 400`
do
    tf=$(awk '{if (NR == '$i') print $1}' $list)
    echo $tf
    gene=$(grep $tf ~/Lab/Reference/Motifs/HOCOMOCOv11_core_annotation_HUMAN_mono.tsv | awk '{print $2}')
    id=$(awk '{if ($7 == "'$gene'") print $4}' ~/Lab/Reference/Human/hg38/GENCODE29/Genes.Basic.bed)
    exp=$(grep $id Gene-Expression-Matrix.K562-HepG2-HCT116-MCF7.txt | awk '{print $1 "\t" $2 "\t" $3}')

    motifFile=$motifDir/$tf.FIMO.txt
    k562=$(awk 'FNR==NR {x[$2];next} ($1 in x)' $motifFile tmp.K562 | wc -l | awk '{print $1}')
    hepg2=$(awk 'FNR==NR {x[$2];next} ($1 in x)' $motifFile tmp.HepG2 | wc -l | awk '{print $1}')
    tk562=$(wc -l tmp.K562 | awk '{print $1}')
    thepg2=$(wc -l tmp.HepG2 | awk '{print $1}')

    echo -e $tf "\t" $k562 "\t" $tk562 "\t" $hepg2 "\t" $thepg2 "\t" $exp  | \
        awk '{if ($NF > 5 || $(NF-1) > 5) print $0}' >> tmp.tf
done

python $scriptDir/fisher-test-tf-motif-fcc.py tmp.tf > tmp.data

awk '{if (($2/$3 > 0.1 || $4/$5 > 0.1) && ($7 > 5 || $8 > 5)) print $0}' tmp.data | awk '{if ($NF < 0.05) print $0 "\t" ($2/$3)/($4/$5)}' | sort -k11,11rg | head -n 5 > tmp.results
awk '{if (($2/$3 > 0.1 || $4/$5 > 0.1) && ($7 > 5 || $8 > 5)) print $0}' tmp.data | awk '{if ($NF < 0.05) print $0 "\t" ($2/$3)/($4/$5)}' | sort -k11,11rg | tail -n 6 | grep -v "GFI1_HUMAN.H11MO.0.C" >> tmp.results

mv tmp.data Figure-Input-Data/Figure-2x.STARR-Motif.txt
mv tmp.results Figure-Input-Data/Figure-2e.STARR-Motif-Enrichment.txt
rm tmp*
