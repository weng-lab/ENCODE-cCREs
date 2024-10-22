source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
gc=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered_monoCG-diCG-NormalizedCG.bed

cd $workingDir


cellTypes=(K562 HepG2 HCT116)
for cellType in ${cellTypes[@]}
do
    paste ../../CORVUS/Input-Sequences/$cellType.PLS-ELS.bed ../../CORVUS/UMAP/UMAP.100.10.$cellType-16CNN-16Dense.txt | sort -k4,4 > tmp.umap
    awk 'FNR==NR {x[$4];next} ($5 in x)' tmp.umap $gc | sort -k5,5 | paste tmp.umap - | \
        awk '{print $4 "\t" $10 "\t" $12 "\t" $13 "\t" $20 "\t" $21 "\t" $22}' > tmp.results-$cellType
    Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/gc-cor.R tmp.results-$cellType | awk '{print "'$cellType'" "\t" $0}'
done

mv tmp.results-K562 Figure-Input-Data/Extended-Data-Figure-2c.VAE-GC-K562.txt
rm tmp.* 
