

## Step 0 - Call DHSs
This script uses Hotspot2 enrichment files from the ENCODE portal to call high resolution DNase Hypersensitivity Sites (DHSs). Because higher sequencing depth results in wider peak calls, this process is done interatively for all experiments at increasing strigency thresholds (0.01 to 1E-4942) until all peaks are less than 350 bp in width.

This script calls the python script `filter-long-double.py`, which is available in the toolkit. This script is also designed to run on an Slurm cluster with one job dedicated to each DNase profile. 


## Step 1

## Step 2
