
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry
cd $workingDir

inputList=Table-Input-Data/Supplementary-Table-4x.DNase-Enrichment-BICCN.txt
biosampleList=biosample-classification.txt

rm -f tmp.selection
tissues=(brain blood lung liver kidney intestine heart skin)
for tissue in ${tissues[@]}
do
    echo $tissue
    grep $tissue biosample-classification.txt | \
        awk 'FNR==NR {x[$1];next} ($2 in x)' - $inputList | \
	awk '{print $0 "\t" "'$tissue'"}'>> tmp.selection
done

mv tmp.selection Figure-Input-Data/Supplementary-Figure-3x.BICCN-cCRE-DNase-Enrichment.txt
rm tmp.*

inputList=Table-Input-Data/Supplementary-Table-4x.DNase-Enrichment-Loupe-Myers.txt
biosampleList=biosample-classification.txt

rm -f tmp.selection
tissues=(brain blood lung liver kidney intestine heart skin)
for tissue in ${tissues[@]}
do
    echo $tissue
    grep $tissue biosample-classification.txt | \
        awk 'FNR==NR {x[$1];next} ($2 in x)' - $inputList | \
        awk '{print $0 "\t" "'$tissue'"}'>> tmp.selection
done

mv tmp.selection Figure-Input-Data/Supplementary-Figure-3x.Loupe-Myers-cCRE-DNase-Enrichment.txt
rm tmp.*
