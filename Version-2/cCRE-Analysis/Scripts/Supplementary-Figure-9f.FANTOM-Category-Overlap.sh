#!/bin/bash

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Script calculates overlap between FANTOM CAT TSSs and cCREs

#TO RUN:
#./Supplementary-Figure-9f.FANTOM-Category-Overlap.sh

dataDir=~/Lab/ENCODE/Encyclopedia/V5/Registry/V5-hg38
ccres=$dataDir/hg38-ccREs-Simple.bed
fantomClass=supp_table_03.CAT_gene_classification.tsv
fantomGTF=FANTOM_CAT.lv3_robust.gtf
chain=~/Lab/Reference/Human/hg38/hg38ToHg19.over.chain

awk -F "\t" '{if (NR != 1) print $1 "\t" $6}' supp_table_03.CAT_gene_classification.tsv \
    | sort -k1,1 > tmp.class
awk '{if ($3 == "gene") print $0}' $fantomGTF | \
    awk '{if ($7 == "-") print $1 "\t" $5-1 "\t" $5 "\t" $10; \
    else print $1 "\t" $4-1 "\t" $4 "\t" $10}' | \
    awk '{gsub(/;/," ");print}' | awk '{gsub(/"/,"");print}' | \
    sort -k4,4 > tmp.tss

paste tmp.tss tmp.class | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $6}' > tmp.bed
~/bin/liftOver -bedPlus=9 $ccres $chain tmp.ccres-hg19 tmp.no-map
bedtools intersect -wo -a tmp.bed -b tmp.ccres-hg19  > tmp.overlap

data=("lncRNA_antisense"
"lncRNA_divergent"
"lncRNA_intergenic"
"lncRNA_sense_intronic"
"coding_mRNA"
"pseudogene"
"sense_overlap_RNA"
"short_ncRNA"
"small_RNA"
"structural_RNA"
"uncertain_coding")

echo -e "category \t total \t pls \t pels \t dels" > tmp.results
for q in ${data[@]}
do
    #d=$(echo $q | awk '{gsub(/_/," ");print}')
    d=$q
    total=$(awk -F "\t" -v d="$d" '{if ($5 == d) total += 1} \
        END{print total}' tmp.overlap)
    pls=$(awk -F "\t" -v d="$d" '{if ($5 == d && $(NF-1) == "P") total += 1} \
        END{print total/'$total'}' tmp.overlap)
    pels=$(awk -F "\t" -v d="$d" '{if ($5 == d && $(NF-1) == "p") total += 1} \
        END{print total'/$total'}' tmp.overlap)
    dels=$(awk -F "\t" -v d="$d" '{if ($5 == d && $(NF-1) == "d") total += 1} \
        END{print total/'$total'}' tmp.overlap)
    echo -e $d "\t" $total "\t" $pls "\t" $pels "\t" $dels >> tmp.results
done

mv tmp.results hg38-FANTOM-Category-Overlap.txt

rm tmp.*
