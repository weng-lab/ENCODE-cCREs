
#Jill Moore
#Moore Lab - UMass Chan
#March 2024

#Usage: ./Extended-Data

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Biosample-Coverage
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis

cd $workingDir

echo -e "Type" "\t" "Count" "\t" "Version" > tmp.summary
echo -e "Type" "\t" "Count" "\t" "Version" > tmp.core

versions=(V5 V6 V7)
for version in ${versions[@]}
do
    echo $version
    dir=~/Lab/ENCODE/Encyclopedia/$version/Registry/$version-hg38
    cat $dir/DNase-List.txt $dir/H3K4me3-List.txt $dir/H3K27ac-List.txt $dir/CTCF-List.txt > $version.All.txt
    python ~/Projects/ENCODE/Encyclopedia/Version6/Curate-Data/classify-biosample-type.py $version.All.txt > tmp.tmp
    awk -F "\t" '{print $3 "\t" $(NF-2)}' tmp.tmp | sort -u > tmp.unique
    python ~/bin/count.py tmp.unique -1 | awk -F "\t" '{print $0 "\t" "'$version'"}' >> tmp.summary
    awk 'FNR==NR {x[$9];next} ($1 in x)' $dir/Cell-Type-Specific/Group-1.txt tmp.unique > tmp.group1
    python ~/bin/count.py tmp.group1 -1 | awk -F "\t" '{print $0 "\t" "'$version'"}' >> tmp.core
done

mv tmp.summary ../Figure-Input-Data/Extended-Data-Figure-1b.Registry-Biosample-Increase.txt 
mv tmp.core ../Figure-Input-Data/Extended-Data-Figure-1c.Registry-Core-Increase.txt
rm tmp.*
