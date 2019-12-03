## ENCODE cCRE pipeline (version 2)

### Step 0 - Call DNase hypersensitive sites (DHSs)

Script calls sequencing-depth independent DHSs from Hotpot2 enrichment files

```
sbatch 0_Call-DHSs.sh
```


Requires: 
* `filter.long.double.py`
* `hg38-Hotspot-List.txt`

### Step 1 - Filter and process DHSs

```
sbatch 1_Process-DHSs.sh
```

Requires:
* `calcuate.zscore.py`
* `hg38-Hotspot-List.txt`

### Step 2 - Create representative DHSs (rDHSs)

### Step 3 - Calculate signal Z-scores

### Step 4 - Determine maximum Z-scores (maxZ)

### Step 5 - Classify cCREs

### Step 6 - Filter cCREs

### Step 7 - Classify cell type specific cCREs (seven group model)

### Step 8 - Classify cell type specific cCREs (nine state model)

### Step 9 - Determine closest genes

### Step 10 - Identify homologous cCREs

### Step 11 - Match cross-assembly cCREs

### Step 12 - Match cross-version cCREs

### Step 13 - Extract high signal elements
