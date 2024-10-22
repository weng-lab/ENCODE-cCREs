source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
k562=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/ENCFF414OGC_ENCFF806YEZ_ENCFF849TDM_ENCFF736UDR.bed
geneMatch=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/PLS-Gene-List.hg38-V4.txt
genes=~/Lab/Reference/Human/hg38/GENCODE40/Genes.Basic.bed
pacBio=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/CORVUS/Annotations/K562/K562-ENCSR983KDL.PacBio-5ends.bed

cd $workingDir

paste ../../CORVUS/Input-Sequences/K562.PLS-ELS.bed ../../CORVUS/UMAP/UMAP.100.10.K562-16CNN-16Dense.txt > tmp.umap

rm -f tmp.results
groups=(protein_coding lncRNA)
for group in ${groups[@]}
do
    echo $group
    grep $group $genes | awk 'FNR==NR {x[$4];next} ($2 in x)' - $geneMatch | \
	awk 'FNR==NR {x[$1];next} ($4 in x)' - tmp.umap | awk '{print $0 "\t" "'$group'"}' >> tmp.results
done

wget https://www.encodeproject.org/files/ENCFF227JQX/@@download/ENCFF227JQX.bed.gz
gunzip ENCFF227JQX.bed

grep dELS tmp.umap | bedtools intersect -u -a stdin -b $pacBio | awk '{print $0 "\t" "PacBio"}' >> tmp.results
grep dELS tmp.umap | bedtools intersect -v -a stdin -b $pacBio | bedtools intersect -u -a stdin -b ENCFF227JQX.bed | \
    awk '{print $0 "\t" "PROcap"}' >> tmp.results
grep dELS tmp.umap | bedtools intersect -v -a stdin -b $pacBio | bedtools intersect -v -a stdin -b ENCFF227JQX.bed | \
    awk '{print $0 "\t" "None"}' >> tmp.results


mv tmp.results Figure-Input-Data/Extended-Data-Figure-2d.VAE-cCRE-Breakdown.txt
rm tmp.* ENCFF227JQX.bed
