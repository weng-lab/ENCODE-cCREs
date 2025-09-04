#Jill Moore
#Moore Lab - UMass Chan
#July 2024

#Usage:

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
vista=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/VISTA/VISTA-hg38.04-22-2023.bed

cd $workingDir

rm -f tmp.results
classes=(dELS)
for class in ${classes[@]}
do
    awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | \
        bedtools intersect -u -a $vista -b stdin | grep "positive" > tmp.1
    awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | \
        awk 'FNR==NR {x[$4];next} !($4 in x)' - ../../hg38-cCREs-Unfiltered.bed | \
        awk '{if ($NF == "'$class'") print $0}' - | \
            bedtools intersect -u -a $vista -b stdin | grep "positive" > tmp.2
    python ~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis/count-vista-tissues.py tmp.1 tmp.2 > tmp.results
done

awk -F "\t" '{print $3 "\t" $1}' tmp.results | sort -k1,1rg | head -n 6 | \
    awk -F "\t" 'FNR==NR {x[$2];next} ($1 in x)' - tmp.results \
    > Figure-Input-Data/Figure-3g.REST-Silencer-VISTA-Enrichment.txt

mv tmp.results Table-Input-Data/Supplementary-Table-X.REST-Silencer-VISTA-Enrichment.txt

