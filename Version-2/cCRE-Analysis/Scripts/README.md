# ENCODE cCRE analysis

---

## Supplementary Figure 2 | Details of building the Registry of cCREs.

### Panels C & H

```
./Supplementary-Figure-2ch.Genomic-Coverage.sh [genome]
```

**Requires:**
* genome: hg38 or mm10
* hg38 or mm10 cCREs
* Chromosome size files: [hg38](https://hgdownload-test.gi.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes) or [mm10](https://hgdownload-test.gi.ucsc.edu/goldenPath/mm10/bigZips/mm10.chrom.sizes)


## Supplementary Figure 8 | Overlap of cCREs with ChromHMM states. 

### Panel A

```
./Supplementary-Figure-8a.Human-ChromHMM-Overlap.sh
```

**Requires:**
* `choose-majority-chromhmm-state.py`
* GM12878 cCREs
* GM12878 ChromHMM states: [ENCFF001TDH](https://www.encodeproject.org/files/ENCFF001TDH/)


### Panel B

```
./Supplementary-Figure-8b.pELS-ChromHMM-TSS-Distance.sh
```

**Requires:**
* `choose-majority-chromhmm-state.py`
* GM12878 cCREs
* GM12878 ChromHMM states: [ENCFF001TDH](https://www.encodeproject.org/files/ENCFF001TDH/)
* [GENCODE24 TSSs](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Pipeline/Input-Data/hg38/GENCODE24/TSS.Basic.bed.gz)


### Panel C

```
./Supplementary-Figure-8c.Mouse-ChromHMM-Overlap.sh Mouse-Data-Key.txt
```

**Requires:**
* `choose-majority-chromhmm-state.py`
* Mouse cCREs
* [Mouse-Data-Key.txt](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Analysis/Input-Data/mm10/DAC-Mouse-ChromHMM/Mouse-Data-Key.txt)
* [DAC Mouse ChromHMM states](https://github.com/weng-lab/ENCODE-cCREs/tree/master/Version-2/cCRE-Analysis/Input-Data/mm10/DAC-Mouse-ChromHMM)

---

## Supplementary Figure 9 

**Overlap of cCREs with FANTOM enhancers and the transcription start sites of FANTOM CAGE-associated transcripts.** Histograms of the Z-scores of cCREs intersecting FANTOM enhancers (colored) and not intersecting FANTOM enhancers (gray). Z-scores are plotted for **a,** DNase; **b,** H3K4me3; **c,** H3K27ac; **d,** H3K4me1; and **e,** Pol II. **f,** Percentages of the transcription start sites of FANTOM CAGE-associated transcripts in the eleven FANTOM-defined categories that overlap cCREs-PLS (red), cCREs-pELS (orange), or cCREs-dELS (yellow). The TSSs of the majority of coding-associated transcripts (protein coding mRNA and divergent lncRNAs) overlapped a cCRE-PLS, while the TSSs of the majority of eRNA-like non-coding RNAs (short ncRNAs, antisense lncRNAs, intergenic lncRNAs, sense intronic lncRNAs, and sense overlap RNAs) overlapped a cCRE-dELS.

### Panels A-E

```
./Supplementary-Figure-9abcde.FANTOM-Enhancer-Intersection.sh
```

**Requires:**
* Human cell type-agnostic cCREs
* FANTOM enhancers: [human_permissive_enhancers_phase_1_and_2.bed](https://fantom.gsc.riken.jp/5/datafiles/latest/extra/Enhancers/human_permissive_enhancers_phase_1_and_2.bed.gz)
* max Z-score files derived from step 4 of the cCRE pipeline


### Panels F

```
./Supplementary-Figure-9f.FANTOM-Category-Overlap.sh
```

**Requires:**
* Human cell type-agnostic cCREs
* LiftOver chain file: [hg38ToHg19.over.chain](http://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz)
* FANTOM CAT gtf: [FANTOM_CAT.lv3_robust.gtf](https://fantom.gsc.riken.jp/5/suppl/Hon_et_al_2016/data/assembly/lv3_robust/FANTOM_CAT.lv3_robust.gtf.gz)
* FANTOM CAT classifications: [supp_table_03.CAT_gene_classification.tsv](https://fantom.gsc.riken.jp/5/suppl/Hon_et_al_2016/data/supp_table/supp_table_03.CAT_gene_classification.tsv)


---

## Supplementary Figure 10 | Conservation of human cCREs

### Panel A

```
./Supplementary-Figure-10a.cCRE-GERP-Overlap.sh
```

**Requires:**
* Human cell type-agnostic cCREs
* LiftOver chain file: [hg19ToHg38.over.chain](http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/hg19ToHg38.over.chain.gz)
* GERP regions: [hg19.GERP_elements](http://mendel.stanford.edu/SidowLab/downloads/gerp/hg19.GERP_elements.tar.gz)
* DNase max Z-score files derived from step 4 of the cCRE pipeline

### Panel C

```
./Supplementary-Figure-10c.cCRE-CAGE-Overlap-Conservation.sh
```

**Requires:**
* `Conservation-Meta-cCRE.sh`
* `Conservation-Meta-cCRE-Single.sh`
* Human cell type-agnostic cCREs
* LiftOver chain file: [hg38ToHg19.over.chain](http://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz)
* Stringent FANTOM CAT peaks: [FANTOM_CAT.lv4_stringent.CAGE_cluster.bed](https://fantom.gsc.riken.jp/5/suppl/Hon_et_al_2016/data/assembly/lv4_stringent/FANTOM_CAT.lv4_stringent.CAGE_cluster.bed.gz)
* PhyloP Conservation: [hg38.phyloP100way.bw](http://hgdownload.cse.ucsc.edu/goldenpath/hg38/phyloP100way/hg38.phyloP100way.bw)

---

## Supplementary Figure 11 | Comparison of cCREs with the ChIP-seq peaks of chromatin-associated proteins and RNA-seq data

### Panel A

```
./Supplementary-Figure-11ab.cCRE-TF-Overlap.sh
```

* `Overlap-TFs.sh`
* `Overlap-CTS-TFs.sh`
* Human cell type-agnostic cCREs
* TF experiment lists: [All biosamples](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Analysis/Input-Data/hg38/All-Biosample-Filtered-TF-List.txt), [GM12878](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Analysis/Input-Data/hg38/GM12878-Filtered-TF-List.txt), [HepG2](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Analysis/Input-Data/hg38/HepG2-Filtered-TF-List.txt), [K562](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Analysis/Input-Data/hg38/K562-Filtered-TF-List.txt)
