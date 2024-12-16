list=Common-List.txt
for j in `seq 1 1 35`
do
    dnaseExp=$(awk '{if (NR == '$j') print $1}' $list)
    dnaseSig=$(grep $dnaseExp ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/DNase-List.txt | awk '{print $2}')
    connections=$(ls encode_e2g_predictions_*$dnaseExp*tsv | head -n 1)

    grep -v Low-DNase ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/$dnaseSig*.bed > tmp.ccres
    bedtools intersect -wo -f 0.5 -a tmp.ccres -b $connections > tmp.intersect
    
    python Toolkit/count-ccre-class-re2g.py | awk '{print "'$dnaseExp'" $0}'
done
