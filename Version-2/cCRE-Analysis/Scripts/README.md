# ENCODE cCRE analysis

---

## Supplementary Figure 2 | Details of building the Registry of cCREs.

### Panels C & H

```
./Supplementary-Figure-2ch.Genomic-Coverage.sh [genome]
```

**Parameters:**
* `genome` : either hg38 for human or mm10 for mouse

**Requires:**
* hg38 or mm10 cCREs
* Chromosome size files: [hg38](https://hgdownload-test.gi.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes) or [mm10](https://hgdownload-test.gi.ucsc.edu/goldenPath/mm10/bigZips/mm10.chrom.sizes)

---


## Supplementary Figure 3 | Classification of cCREs in a particular biosample

### Panel D

```
./Supplementary-Figure-3d.cCRE-Biosample-Count.sh
```

**Requires:**
* Cell type-agnositic cCREs
* Cell type-specific cCREs
* Biosample experiment matrix (Step 6 of cCRE pipeline)

---

## Supplementary Figure 4 | UCSC Genome Browser views of cCREs and the underlying DNase and ChIP data

### Panel A
UCSC genome browser: [*SPI1*](https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&position=chr11:47371158-47397795&hubClear=https://users.wenglab.org/moorej3/ENCODE-cCREs/Track-Hubs/hub-SF4a.txt)

### Panel B
UCSC genome browser: [*NPAS4*](https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&position=chr11:66415362-66432380&hubClear=https://users.wenglab.org/moorej3/ENCODE-cCREs/Track-Hubs/hub-SF4b.txt)

### Panel C
UCSC genome browser: [*HNF4A*](https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&position=chr20:44344991-44392365&hubClear=https://users.wenglab.org/moorej3/ENCODE-cCREs/Track-Hubs/hub-SF4c.txt)

---

## Supplementary Figure 7 | Coverage of the current Registry of cCREs

```
./Supplementary-Figure-7.ChIP-Peak-Overlap.sh [genome]
```

**Parameters:**
* `genome` : either hg38 for human or mm10 for mouse

**Requires:**
* `Batch-Run-Calculate-Peak-Overlap.sh`
* Cell type-agnostic cCREs
* Biosample experiment matrix (Step 6 of cCRE pipeline)


---

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

## Supplementary Figure 9 | Overlap of cCREs with FANTOM enhancers and the transcription start sites of FANTOM CAGE-associated transcripts

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

---

## Supplementary Figure 12 | Transcription patterns at cCREs

### Panel A

```
./Supplementary-Figure-11ab.cCRE-TF-Overlap.sh
```

---

## Supplementary Figure 17 | Using cCREs to annotate functional SNPs related to red blood cell traits

### Panel A

```
./Supplementary-Figure-17a.Overlap-RBC-MPRA.sh
```
**Requires:**
* Cell type-agnostic cCREs
* K562 cCREs
* Supplemental tables from Ulirsch...Sankaran (2016) *Cell*: [Table S1](https://www.cell.com/cms/10.1016/j.cell.2016.04.048/attachment/a4c39614-2600-4f7e-81e3-ad71fcb6ac7b/mmc2.xlsx), [Table S2](https://www.cell.com/cms/10.1016/j.cell.2016.04.048/attachment/afbef448-f1db-4d42-80bb-41dd04a1f25e/mmc3.xlsx)


### Panel B
UCSC genome browser: [*RBM38*](https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&position=chr20:57386938-57437523&hubClear=https://users.wenglab.org/moorej3/ENCODE-cCREs/Track-Hubs/hub-SF17b.txt)

### Panel C
SCREEN: [EH38E2124446](https://screen.encodeproject.org/search/?q=EH38E2124446&assembly=GRCh38&uuid=b219b494-460e-4469-a1dc-111c7ee4800c)

### Panel D
SCREEN: [EM10E0721638](https://screen.encodeproject.org/search/?q=EM10E0721638&assembly=mm10&uuid=fbe63b21-0cdc-422a-99b7-623a0f70d0a4)
