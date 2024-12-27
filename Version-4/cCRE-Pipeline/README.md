

## Step 0 - Call DHSs
This script uses Hotspot2 enrichment files from the ENCODE portal to call high resolution DNase Hypersensitivity Sites (DHSs). Because higher sequencing depth results in wider peak calls, this process is done interatively for all experiments at increasing strigency thresholds (0.01 to 1E-4942) until all called regions are less than 350 bp in width.

This script was designed to run on a Slurm cluster with one job dedicated to each DNase profile. 

Input data:
* [hg38-Hotspot-List.txt.gz](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-Hotspot-List.txt.gz)
* [mm10-Hotspot-List.txt.gz](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Hotspot-List.txt.gz)


Additional scripts:
* [filter-long-double.py](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-4/cCRE-Pipeline/Toolkit/filter-long-double.py)


## Step 1 - Process DHSs
This script calculates the average DNase signal across DHSs called in Step 0, which are used in Step 2 for filtering.

This script was designed to run on a Slurm cluster with one job dedicated to each DNase profile.

Input data:
* [hg38-Hotspot-List.txt.gz](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/hg38-Hotspot-List.txt.gz)
* [mm10-Hotspot-List.txt.gz](https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/mm10-Hotspot-List.txt.gz)

Required software:
* bigWigAverageOverBed ([UCSC Genome Browser Utilities](https://hgdownload.soe.ucsc.edu/admin/exe/))

 
## Step 2
