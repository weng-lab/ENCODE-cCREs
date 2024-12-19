
grep EH38E3620079 ../../hg38-cCREs-Unfiltered.bed | bedtools intersect -u -a ../../hg38-TF/All-K562-Peak-Summits.bed -b stdin | awk '{print $5":"$4}'
grep EH38E3620077 ../../hg38-cCREs-Unfiltered.bed | bedtools intersect -u -a ../../hg38-TF/All-K562-Peak-Summits.bed -b stdin | awk '{print $5":"$4}'
grep EH38E3620078 ../../hg38-cCREs-Unfiltered.bed | bedtools intersect -u -a ../../hg38-TF/All-K562-Peak-Summits.bed -b stdin | awk '{print $5":"$4}'

