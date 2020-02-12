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

### Step 6 - Filter cCREs

### Step 7 - Classify cell type specific cCREs (seven group model)

### Step 8 - Classify cell type specific cCREs (nine state model)

### Step 9 - Determine closest genes

### Step 10 - Identify homologous cCREs

### Step 11 - Match cross-assembly cCREs

### Step 12 - Match cross-version cCREs

### Step 13 - Extract high signal elements

