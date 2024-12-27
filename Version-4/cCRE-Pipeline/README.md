

## Step 0 - Call DHSs
This script uses Hotspot2 enrichment files from the ENCODE portal to call high resolution DNase Hypersensitivity Sites (DHSs). Because higher sequencing depth results in wider peak calls, this process is done interatively for all experiments at increasing strigency thresholds (0.01 to 1E-4942) until all called regions are less than 350 bp in width.

This script was designed to run on a Slurm cluster with one job dedicated to each DNase profile. 

**Input data:**
* [hg38-Hotspot-List.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-Hotspot-List.txt.gz)
* [mm10-Hotspot-List.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Hotspot-List.txt.gz)


**Additional scripts:**
* [filter-long-double.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/filter-long-double.py)


## Step 1 - Process DHSs
This script calculates the average DNase signal across DHSs called in Step 0, which are used in Step 2 for filtering.

This script was designed to run on a Slurm cluster with one job dedicated to each DNase profile.

**Input data:**
* [hg38-Hotspot-List.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-Hotspot-List.txt.gz)
* [V1-V2-V3.rDHS-hg38.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/V1-V2-V3.rDHS-hg38.bed.gz)
* [mm10-Hotspot-List.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Hotspot-List.txt.gz)
* [V1-V2-V3.rDHS-mm10.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/V1-V2-V3.rDHS-mm10.bed.gz)

**Required software:**
* bigWigAverageOverBed ([UCSC Genome Browser Utilities](https://hgdownload.soe.ucsc.edu/admin/exe/))

 
## Step 2
This script generates representative DHSs (rDHSs) from DHSs called across multiple DNase profiles (Step 1). DHSs are first filtered by width (>= 150 bp), signal (> than 10%tile), and FDR( <= 0.001) and then concatenated into one large BED file. These regions are then merged. For each merged region, a representative DHS is selected based on the highest signal. These rDHSs are intersected with the total concatenated BED file and the process is repeated until all individual DHSs overlap an rDHS. We then accession rDHSs, using previous IDs if the coordinates are identical to previous version of the Registry. Finally, rDHSs are intersected with consensus DNase Hypersensitivity sites (cDHSs and rDHSs that overlap entirely, overlap by at least 135 bp, or have the 90%tile signal are retained.


**Input data:**
* [Altius-cDHSs.DAC-hg38.bed.gz](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/Altius-cDHSs.DAC-hg38.bed.gz)
* [Altius-cDHSs.DAC-mm10.bed.gz](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/Altius-cDHSs.DAC-mm10.bed.gz)

**Additional scripts:**
* [pick-best-peak.py]()
* [make-region-accession.py]()
* [calculate-cdhs-percentile.py]()

**Required software:**
* [BEDTools](https://bedtools.readthedocs.io/en/latest/)

