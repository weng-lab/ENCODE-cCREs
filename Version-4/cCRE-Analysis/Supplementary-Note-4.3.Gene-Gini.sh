

gini=/zata/public_html/users/elhajjajys/cCRE_paper/tissue_specificity/RNAseq_matrix.avg.quantile.gini.tsv
genes=~/Lab/Reference/Human/hg38/GENCODE40/Genes.Basic.bed


grep protein_coding $genes | awk '{print $4}' > tmp.pc
grep lncRNA $genes | awk '{print $4}' > tmp.lnc


awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' tmp.pc $gini | awk '{print $0 "\t" "PC"}' > tmp.out
awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' tmp.lnc $gini | awk '{print $0 "\t" "LNC"}' >> tmp.out
