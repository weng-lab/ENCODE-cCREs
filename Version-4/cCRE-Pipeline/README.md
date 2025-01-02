
# ENCODE4 cCRE Pipeline

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
* [mm10-Hotspot-List.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Hotspot-List.txt.gz)

**Required software:**
* bigWigAverageOverBed ([UCSC Genome Browser Utilities](https://hgdownload.soe.ucsc.edu/admin/exe/))

 
## Step 2 - Create rDHSs
This script generates representative DHSs (rDHSs) from DHSs called across multiple DNase profiles (Step 1). DHSs are first filtered by width (>= 150 bp), signal (> than 10%tile), and FDR( <= 0.001) and then concatenated into one large BED file. These regions are then merged. For each merged region, a representative DHS is selected based on the highest signal. These rDHSs are intersected with the total concatenated BED file and the process is repeated until all individual DHSs overlap an rDHS. We then accession rDHSs, using previous IDs if the coordinates are identical to previous version of the Registry. Finally, rDHSs are intersected with consensus DNase Hypersensitivity sites (cDHSs and rDHSs that overlap entirely, overlap by at least 135 bp, or have the 90%tile signal are retained.


**Input data:**
* [Altius-cDHSs.DAC-hg38.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/Altius-cDHSs.DAC-hg38.bed.gz)
* [V1-V2-V3.rDHS-hg38.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/V1-V2-V3.rDHS-hg38.bed.gz)
* [Altius-cDHSs.DAC-mm10.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/Altius-cDHSs.DAC-mm10.bed.gz)
* [V1-V2-V3.rDHS-mm10.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/V1-V2-V3.rDHS-mm10.bed.gz)

**Additional scripts:**
* [pick-best-peak.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/pick-best-peak.py)
* [make-region-accession.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/make-region-accession.py)
* [calculate-cdhs-percentile.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/calculate-cdhs-percentile.py)

**Required software:**
* [BEDTools](https://bedtools.readthedocs.io/en/latest/) (version 2.30.0 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))

## Step 3 - Curate TF Clusters
This script generates transcription factor clusters from peaks called across multiple ChIP-seq experiments. We download peaks from the ENCODE portal with a FRiP score > 0.003 and resize peaks so that they are between 150 and 350 bp in width. These peaks are concatenated into one large BED file and then merged. For each merged region, a representative peak is selected based on the highest signal. These rPeaks are intersected with the total concatenated BED file and the process is repeated until all individual peaks overlap an rPeak. We then select all rPeaks that overlap the summits of at least 5 peaks and do not overlap an rDHS. These TF clusters are then accessioned and complement rDHSs as anchors for cCREs.

**Input data:**
* [hg38-TF-List.All.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-TF-List.All.txt.gz)
* [mm10-TF-List.All.txt](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-TF-List.All.txt.gz)

**Additional scripts:**
* [pick-best-peak.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/pick-best-peak.py)
* [make-region-accession.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/make-region-accession.py)
* [filter-tf-rpeaks.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/filter-tf-rpeaks.py)
* [pull-tf-experiments.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/pull-tf-experiments.py)

**Required software:**
* [BEDTools](https://bedtools.readthedocs.io/en/latest/) (version 2.30.0 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))

## Step 4 - Calculate signal z-scores
This script calculates a normalized signal z-score for each anchor given a list of bigWig files. For each experiment, we calculate the average signal across each anchor region. For DNase and CTCF, this is across the anchor itelf and for histone marks this is the anchor +/- 500 bp. This signal is then converted to a z-score with values of 0 removed from the calculation. 

This script was designed to run on a Slurm cluster with one job dedicated to each bigWig file.

**Input data:**
* [hg38-Anchors.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-Anchors.bed.gz) (concatenated rDHSs from **Step 2** and TF clusters from **Step 3**)
* [mm10-Anchors.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Anchors.bed.gz) (concatenated rDHSs from **Step 2** and TF clusters from **Step 3**)
* List of experiment accessions:
	* [Human](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-Experiment-Lists.tar.gz)
	* [Mouse](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Experiment-Lists.tar.gz)

**Additional scripts:**
* [Retrieve-Signal.sh](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/Retrieve-Signal.sh)
* [download-portal-file.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/download-portal-file.py)
* [log-zscore-normalization.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/log-zscore-normalization.py)

**Required software:**
* bigWigAverageOverBed ([UCSC Genome Browser Utilities](https://hgdownload.soe.ucsc.edu/admin/exe/))


## Step 5 - Determine maximum z-scores
This script calculate the max z-score for each Anchor across all experiment for each signal type (e.g., DNase, H3K4me3, etc.) These max z-scores are then used for filtering and classifying cCREs.

**Input data:**
* Signal z-score quantifications from **Step 4**.
* List of experiment accessions:
        * [Human](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-Experiment-Lists.tar.gz)
        * [Mouse](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Experiment-Lists.tar.gz)

**Additional scripts:**
* [select-max-zscore.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/select-max-zscore.py)

## Step 6 - Classify cCREs
This script performs cell type-agnostic classification of cCREs using the following logic:
* Promoter-like signatures (*promoter*) must fall within 200 bp of a TSS and have high chromatin accessibility and H3K4me3 signals.
* TSS-proximal enhancer-like signatures (*proximal enhancer*) have high chromatin accessibility and H3K27ac signals and are within 2 kb of an annotated TSS. If they are within 200 bp of a TSS, they must also have low H3K4me3 signal.
* TSS-distal enhancer-like signatures (*distal enhancer*) have high chromatin accessibility and H3K27ac signals and are farther than 2 kb from an annotated TSS. 
* Chromatin accessibility + H3K4me3 (*CA-H3K4me3*) have high chromatin accessibility and H3K4me3 signals but low H3K27ac signals and do not fall within 200 bp of a TSS.
* Chromatin accessibility + CTCF (*CA-CTCF*) have high chromatin accessibility and CTCF signals but low H3K4me3 and H3K27ac signals. 
* Chromatin accessibility + transcription factor (*CA-TF*) have high chromatin accessibility, low H3K4me3, H3K27ac, and CTCF signals, and are bound by a transcription factor.
* Chromatin accessibility (*CA*) have high chromatin accessibility and low H3K4me3, H3K27ac, and CTCF signals.
* Transcription factor (*TF*) have low chromatin accessibility, low H3K4me3, H3K27ac, and CTCF signals and are bound by a transcription factor.

GENCODEV40 annotations were used for human and GENOCDEM25 annotations were used for mouse.

**Input data:**
* Anchor regions (rDHSs + TF clusters)
* Max Z-score files from **Step 5**
* [GENCODEV40-TSS.Basic.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEV40-TSS.Basic.bed.gz)
* [GENCODEV40-TSS.Basic.4K.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEV40-TSS.Basic.4K.bed.gz)
* [GENCODEM25-TSS.Basic.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEM25-TSS.Basic.bed.gz)
* [GENCODEM25-TSS.Basic.4K.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEM25-TSS.Basic.4K.bed.gz)
* [V1-V2-V3.cCREs-hg38.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/V1-V2-V3.cCREs-hg38.bed.gz)
* [V1-V2-V3.cCREs-mm10.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/V1-V2-V3.cCREs-mm10.bed.gz)

**Additional scripts:**
* [make-region-accession.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/make-region-accession.py)

**Required software:**
* [BEDTools](https://bedtools.readthedocs.io/en/latest/) (version 2.30.0 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))

## Step 7 - Call cell type-specific cCREs

## Step 8 - Assign promoters to genes
This script assigns promoter cCREs to GENCODE annotated genes. cCREs are assigned to genes if they (1) overlap an annotated transcription start site (TSS) or (2) their center is within 200 bp of an annotated TSS. Genes can be assigned to multiple genes if they overlap multiple TSSs. 


**Input data:**
* [GENCODEV40-TSS.Basic.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEV40-TSS.Basic.bed.gz)
* [GENCODEV40-TSS.Basic.4K.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEV40-TSS.Basic.4K.bed.gz)
* [GENCODEM25-TSS.Basic.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEM25-TSS.Basic.bed.gz)
* [GENCODEM25-TSS.Basic.4K.bed](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/GENCODEM25-TSS.Basic.4K.bed.gz)

**Additional scripts:**
* [calculate-center-distance.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/calculate-center-distance.py)

**Required software:**
* [BEDTools](https://bedtools.readthedocs.io/en/latest/) (version 2.30.0 was used in [Moore...Weng (2024) *bioRxiv*](https://www.biorxiv.org/content/10.1101/2024.12.26.629296v1))
