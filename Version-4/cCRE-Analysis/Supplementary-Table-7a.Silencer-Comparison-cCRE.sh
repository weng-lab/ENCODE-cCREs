silencerDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers/Published-Silencers/
starr=../2_Functional-Characterization/Reddy-WG-STARR/ENCSR661FOW-DESeq2.Solo-Filtered.V7.txt
ccres=../../hg38-cCREs-Unfiltered.bed

testedRegions=$silencerDir/Jayavelu-Hawkins-2020/Tested-Regions.hg38.bed
silencerRegions=$silencerDir/Jayavelu-Hawkins-2020/Candidate-Silencers.hg38.bed

bedtools intersect -a $ccres -b $testedRegions > tmp.tested
bedtools intersect -a $ccres -b $silencerRegions > tmp.silencer
wc -l tmp.tested
wc -l tmp.silencer

awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.silencer $starr | awk '{print $1 "\t" $3 "\t" "silencer"}' > tmp.results
awk 'FNR==NR {x[$4];next} !($4 in x)' tmp.silencer tmp.tested | awk 'FNR==NR {x[$4];next} ($1 in x)' - $starr | awk '{print $1 "\t" $3 "\t" "tested"}' >> tmp.results
awk 'FNR==NR {x[$4];next} !($1 in x)' tmp.tested $starr | sort -R | head -n 100000 | awk '{print $1 "\t" $3 "\t" "not-tested"}' >> tmp.results

~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/silencer-comparison-starr.R
mv tmp.results Published-Silencers/Jayavelu-Hawkins-2020/CAPRA-Summary.txt

testedRegions=$silencerDir/Pang-Snyder-2020/Tested-Regions.hg38.bed
silencerRegions=$silencerDir/Pang-Snyder-2020/Called-Silencers.K562.hg38.bed

bedtools intersect -a $ccres -b $testedRegions > tmp.tested
bedtools intersect -a $ccres -b $silencerRegions > tmp.silencer
wc -l tmp.tested
wc -l tmp.silencer

awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.silencer $starr | awk '{print $1 "\t" $3 "\t" "silencer"}' > tmp.results
awk 'FNR==NR {x[$4];next} !($4 in x)' tmp.silencer tmp.tested | awk 'FNR==NR {x[$4];next} ($1 in x)' - $starr | awk '{print $1 "\t" $3 "\t" "tested"}' >> tmp.results
awk 'FNR==NR {x[$4];next} !($1 in x)' tmp.tested $starr | sort -R | head -n 100000 | awk '{print $1 "\t" $3 "\t" "not-tested"}' >> tmp.results

Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/silencer-comparison-starr.R
mv tmp.results Published-Silencers/Pang-Snyder-2020/CAPRA-Summary.txt

silencerRegions=$silencerDir/Huan-Ovcharenko-2019/K562.hg38.bed
bedtools intersect -a $ccres -b $silencerRegions > tmp.silencer
wc -l tmp.silencer
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.silencer $starr | awk '{print $1 "\t" $3 "\t" "silencer"}' > tmp.results
awk 'FNR==NR {x[$4];next} !($1 in x)' tmp.silencer $starr | sort -R | head -n 100000 | awk '{print $1 "\t" $3 "\t" "not-silencer"}' >> tmp.results
Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/silencer-comparison-starr.R
mv tmp.results Published-Silencers/Huan-Ovcharenko-2019/CAPRA-Summary.txt

silencerRegions=$silencerDir/Cai-Fullwood-2021/MRR.K562.hg38.bed
bedtools intersect -a $ccres -b $silencerRegions > tmp.silencer
wc -l tmp.silencer
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.silencer $starr | awk '{print $1 "\t" $3 "\t" "silencer"}' > tmp.results
awk 'FNR==NR {x[$4];next} !($1 in x)' tmp.silencer $starr | sort -R | head -n 100000 | awk '{print $1 "\t" $3 "\t" "not-silencer"}' >> tmp.results
Rscript ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/silencer-comparison-starr.R
mv tmp.results Published-Silencers/Cai-Fullwood-2021/CAPRA-Summary.txt
