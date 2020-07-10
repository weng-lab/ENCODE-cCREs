# ENCODE cCRE analysis

---

## Supplementary Figure 8

**Overlap of cCREs with ChromHMM states. a,** Percentages of various groups of GM12878 cCREs that overlap ChromHMM states. **b,** Percentage of GM12878 cCREs-pELS that overlap ChromHMM states ranked by distance from the nearest TSS. Due to ChromHMM's lower spatial resolution, cCREs-PLS that are closest to TSSs overlap promoter ChromHMM states while those farther away overlap enhancer states. **c,** Percentages of mouse cCREs that overlap ChromHMM states in the corresponding tissue. All combinations of tissues and timepoints with both DNase and histone modification data were included and the overlap was computed for data in the same tissue at the same time point.

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
