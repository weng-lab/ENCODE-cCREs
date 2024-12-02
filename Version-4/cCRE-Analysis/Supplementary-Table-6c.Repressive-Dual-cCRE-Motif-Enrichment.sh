#Jill Moore
#Moore Lab - UMass Chan
#February 2024

#Usage: ./Extended-Data-Figure-3a.STARR-Cross-Cell.sh

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

awk '{if ($(NF-1) < 0.05 && $3 > 0) print $1}' Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt | awk 'FNR==NR {x[$1];next} ($1 in x)' - Figure-Input-Data/Supplementary-Figure-6c.CAPRA-Solo-Double-Scatter.1.txt | awk '{if ($2 > $4 && $5 < $2 && $5 < $6 && $4 < 0 && $5 < 0) print $0}' > dom-rep-2.txt
awk '{if ($(NF-1) < 0.05 && $3 > 0) print $1}' Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt | awk 'FNR==NR {x[$1];next} ($3 in x)' - Figure-Input-Data/Supplementary-Figure-6c.CAPRA-Solo-Double-Scatter.1.txt | awk '{if ($2 < $4 && $5 < $4 && $5 < $6 && $2 < 0 && $5 < 0) print $0}' >> dom-rep-2.txt

expression=Gene-Expression-Matrix.K562-HepG2-HCT116-MCF7.txt

awk '{if ($2 < 0) print $1; else print $3}' dom-rep-2.txt | sort -u > tmp.2-low
awk '{if ($2 < 0) print $3; else print $1}' dom-rep-2.txt | sort -u > tmp.2-high

rm -f tmp.tf
list=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/HOCOMOCO-List.txt
motifDir=/data/zusers/moorej3/moorej.ghpcc.project/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs/
for i in `seq 1 1 400`
do
    tf=$(awk '{if (NR == '$i') print $1}' $list)
    echo $tf
    gene=$(grep $tf ~/Lab/Reference/Motifs/HOCOMOCOv11_core_annotation_HUMAN_mono.tsv | awk '{print $2}')
    id=$(awk '{if ($7 == "'$gene'") print $4}' ~/Lab/Reference/Human/hg38/GENCODE29/Genes.Basic.bed)
    exp=$(grep $id Gene-Expression-Matrix.K562-HepG2-HCT116-MCF7.txt | awk '{print $1 "\t" $2}')

    motifFile=$motifDir/$tf.FIMO.txt
    dom2=$(awk 'FNR==NR {x[$2];next} ($1 in x)' $motifFile tmp.2-low | wc -l | awk '{print $1}')
    high2=$(awk 'FNR==NR {x[$2];next} ($1 in x)' $motifFile tmp.2-high | wc -l | awk '{print $1}')

    t1=$(wc -l tmp.2-low | awk '{print $1}')
    t2=$(wc -l tmp.2-high | awk '{print $1}')

    echo -e $tf "\t" $dom2 "\t" $t1 "\t" $high2 "\t"$t2 "\t" $exp | 
        awk '{if ($NF > 5) print $0}' >> tmp.tf
done

python $scriptDir/fisher-test-tf-motif-fcc.py tmp.tf > tmp.data

awk '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf "\t%s",$i ; print ""}' tmp.data > Figure-Input-Data/Supplementary-Table-6x.Repressive-Dual-cCRE-TF-Enrichment.txt
mv dom-rep-2.txt Data-Collections/Supplementary-Dataset-X.Repressive-Dual-cCRE-Pairs.txt
rm tmp*
