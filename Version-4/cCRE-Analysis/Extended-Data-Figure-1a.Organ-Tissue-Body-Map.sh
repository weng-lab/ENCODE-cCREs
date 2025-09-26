#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Extended Data Figure 1a

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/Toolkit


#wget https://users.moore-lab.org/ENCODE-cCREs/Pipeline-Input-Files/V4-GRCh38-Biosample-Matrix.txt.gz
#gunzip V4-GRCh38-Biosample-Matrix.txt.gz

cd $workingDir

python $scriptDir/assign-organ-tissue.py V4-GRCh38-Biosample-Matrix.txt GRCh38 > tmp.list
python $scriptDir/count.py tmp.list -1 | sort -k1,1 > Figure-Input-Data/Extended-Data-Figure-1a.Organ-Tissue-Body-Map.txt
mv tmp.list GRCh38-Organ-Tissue-Assignments.txt

rm -f tmp*
