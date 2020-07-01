## ENCODE cCRE pipeline (version 2)

### Step 0 - Call DNase hypersensitive sites (DHSs)

Script calls sequencing-depth independent DHSs from Hotpot2 enrichment files

```
sbatch 0_Call-DHSs.sh
```


Requires: 
* `filter.long.double.py`
* `hg38-Hotspot-List.txt` OR `mm10-Hotspot-List.txt`

### Step 1 - Filter and process DHSs

```
sbatch 1_Process-DHSs.sh
```

Requires:
* `calcuate.zscore.py`
* `hg38-Hotspot-List.txt` OR `mm10-Hotspot-List.txt`

### Step 2 - Create representative DHSs (rDHSs)

```
./2_Create-rDHSs.sh {genome}
```

Parameters:
* `genome` : either hg38 for human or mm10 for mouse

Requires:
* `pick.best.peak.py`
* `make.region.accession.py`
* `percentile.py`
* `{genome}-Stam-cDHS-All.bed`
* `rDHS.hg19-hg38.bed` OR `rDHS.mm10.bed`
* Peak calls from step 1

### Step 3 - Calculate signal Z-scores
```
./3_Calculate-Signal-Zscores.sh {genome} {signal}
```

Parameters:
* `genome` : either hg38 for human or mm10 for mouse
* `signal` : either DNase, H3K4me3, H3K27ac, or CTCF

Requires:
* `RetrieveSignal.sh`
  * `log.zscore.normalization.py`
* `{signal}-List.txt` 
* `{genome}-rDHS-Filtered.bed` output from step 2



### Step 4 - Determine maximum Z-scores (maxZ)
```
./4_Determine-Max-Zscores.sh {genome} {signal}
```

Parameters:
* `genome` : either hg38 for human or mm10 for mouse
* `signal` : either DNase, H3K4me3, H3K27ac, or CTCF

Requires:
* `max.zscore.array.py`
* Signal output files from step 3

### Step 5 - Classify cCREs
```
./5_Classify-ccREs.sh {genome}
```

Parameters:
* `genome` : either hg38 for human or mm10 for mouse

Requires:
* `calculate-center-distance.py`
* `make.region.accession.py`
* maxZ files for DNase, H3K4me3, H3K27ac, and CTCF from step 4
* if applicable: previous versions of registry for consistent accessioning



### Step 6 - Filter cCREs

cCREs are further annotated based on the biosample and epigenomic signal support.

Tier 1 cCREs are supported by high DNase and high ChIP-seq signals in the same cell type. Tier 2 cCREs are supported by high DNase in one cell type and high ChIP-seq signals in another cell type. Examples can be found below:

<img src="https://dl.dropboxusercontent.com/s/2pce7vbxf8o9in5/Box-1-Figure-2.png"
     alt="cCRE tiers" width="50%"
     />

Tier 3 and Tier 4 cCREs are still annotated and accessioned but not included in the final list of cCREs.

```
./6_Filter-ccREs.sh {genome}
```

Parameters:
* `genome` : either hg38 for human or mm10 for mouse

Requires:
* `Extract-Concordant.sh`
* `Extract-Class.sh`
* `match.biosamples.py`
* `summarize.class.py`
* Experiment lists:
  * [hg38](https://github.com/weng-lab/ENCODE-cCREs/tree/master/Version-2/cCRE-Pipeline/Input-Data/hg38/Experiment-Lists)
  * [mm10](https://github.com/weng-lab/ENCODE-cCREs/tree/master/Version-2/cCRE-Pipeline/Input-Data/mm10/Experiment-Lists)
* Pre-filtered cell type agnostic cCREs 

### Step 7 - Classify cell type specific cCREs (seven group model)

Script that will classify cCREs in individual biosamples. For biosamples with four core marks (DNase, H3K4me3, H3K27ac, and CTCF), cCREs will be assigned to the following groups:
* PLS = promoter-like signatures
* pELS = proximal enhancer-like signatures
* dELS = distal enhancer-like signatures
* DNase-H3K4me3 = high DNase, high H3K4me3 but low H3K27ac 
* CTCF-only = only high DNase and CTCF
* DNase-only = only high DNase
* Low-DNase = low DNase signal

For biosamples that lack H3K4me3, H3K27ac, or CTCF signal, a subset of assignments will be made 
For biosamples that lack DNase, only high/low signals will be annotated

```
./7_Cell-Type-Specific-Seven-Group.sh {genome}
```

**Parameters:**
* `genome` : either hg38 for human or mm10 for mouse

**Requires:**
* `Split-cCREs.DNase.sh`
* `Split-cCREs.NoDNase.sh`
* `calculate-center-distance.py`
* GENCODE TSS annotations (GENCODE24 or GENCODEM18)
  * TSS.Basic.bed
  * TSS.Basic.4k.bed
* Chromosome sizes (for bedToBigBed)
  * https://hgdownload-test.gi.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes
  * http://hgdownload.cse.ucsc.edu/goldenPath/mm10/bigZips/mm10.chrom.sizes
* bedPlus file [cre.as](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Pipeline/Input-Data/cres.as)
* Cell type-agnostic cCRE bed files
* Biosample experiment matrix (Step 6)
* Signal summary files for: DNase, H3K4me3, H3K27ac, and CTCF (Step 3)


### Step 8 - Classify cell type specific cCREs (nine state model)

```
./8_Cell-Type-Specific-Nine-State.sh {genome}
```

**Parameters:**
* `genome` : either hg38 for human or mm10 for mouse

Requires:
*


### Step 9 - Determine closest genes

Determines the five closest GENCODE genes (any genes and protein coding genes) as measure by distance to annotated transcript start site. It is designed to run on Slurm servers.

```
./9_Determine-Closest-Genes.sh {genome}
```

**Parameters:**
* `genome` : either hg38 for human or mm10 for mouse

**Requires:**
* GENCODE gene and TSS annotations (GENCODE24 or GENCODEM18)
  * Genes.Basic.bed
  * Genes.Basic-PC.bed
  * TSS.Basic.bed
  * TSS.Basic-PC.bed  
* Cell type-agnostic cCRE bed files

### Step 10 - Identify homologous cCREs

---

Script maps human and mouse cCREs over to the other species genome and then reports a list of cCREs that have two-way homology. It is designed to run on Slurm servers.

```
./10_Homologous-ccREs.sh
```

**Requires:**
* `Batch-LiftOver.sh`
* LiftOver chain files: 
  * http://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToMm10.over.chain.gz
  * http://hgdownload.cse.ucsc.edu/goldenpath/mm10/liftOver/mm10ToHg38.over.chain.gz
* Cell type-agnostic cCRE bed files


