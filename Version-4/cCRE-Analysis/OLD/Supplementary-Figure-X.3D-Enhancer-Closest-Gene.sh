
cd ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/3D-Links/Closest-Gene-Analysis

list=../Three-Assay-Matched-List.txt
ccreDir=../../Cell-Type-Specific/Individual-Files
chiapetDir=/data/projects/encode/3D-Chromatin/ChIA-PET/Ruan-ENCODE4/
dataDir=/data/projects/encode/data/
tss=~/Lab/Reference/Human/hg38/GENCODE40/TSS.Basic-PC.bed
genes=~/Lab/Reference/Human/hg38/GENCODE40/Genes.Basic-PC.bed
cutoff=1
min=8000

for i in `seq 1 1 6`
do
#    echo $i
    cell=$(awk '{if (NR == '$i') print $1}' $list | awk -F "_" '{print $3}')
    dnase=$(awk '{if (NR == '$i') print $9}' $list)
    grep PLS $ccreDir/$dnase*bed > tmp.pls

    rnap2=$(awk '{if (NR == '$i') print $2}' $list)
    ctcf=$(awk '{if (NR == '$i') print $4}' $list)
    #hic1=$(awk '{if (NR == '$i') print $18}' $list)
    hic=$(awk '{if (NR == '$i') print $20}' $list)

    #links=$chiapetDir/$ctcf.DAC-Links.V2.bedpe
    awk '{if (NR > 2) print $0}' ../HiC/$hic*.bedpe > filtered.links
    links=filtered.links
    totalLinks=$(wc -l $links | awk '{print $1}')

    rnaExp=$(awk '{if (NR == '$i') print $16}' $list)
    tsvs=$(awk '{if (NR == '$i') print $17}' $list | awk '{gsub(/;/,"\t");print}' )

    echo "" > tmp.matrix
    for tsv in ${tsvs[@]}
    do
        awk '{print $1 "\t" $6}' $dataDir/$rnaExp/$tsv.tsv | paste tmp.matrix - > tmp.tmp
        mv tmp.tmp tmp.matrix
    done
    awk '{sum=0; for(i=2;i<=NF;i+=2) sum += $i; print $1 "\t" sum/(NF/2)}' tmp.matrix > tmp.rna-quants

    awk '{print $1 "\t" $2 "\t" $3 "\t" "id-"NR "\n" $4 "\t" $5 "\t" $6 "\t" "id-"NR}' $links > tmp.links
    cat $links | awk '{print $1 "\t" $2 "\t" $3 "\t" "id-"NR "\n" $4 "\t" $5 "\t" $6 "\t" "id-"NR}' > tmp.links
    bedtools intersect -c -a tmp.pls -b tmp.links > tmp.overlaptot

    cat tmp.overlaptot | bedtools intersect -u -b stdin -a tmp.links > tmp.overlap
    python ../../count.py tmp.overlap -1 > tmp.count
    awk '{if ($NF > 1) print $0}' tmp.count > tmp.multiple
    awk '{if ($NF == 1) print $0}' tmp.count > tmp.1
    awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.1 tmp.links | \
        awk 'FNR==NR {x[$1$2$3];next} !($1$2$3 in x)' tmp.overlap - > tmp.candidates

    plsCount=$(wc -l tmp.multiple | awk '{print $1}')
    pelsCount=$(grep pELS $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.candidates -b stdin | wc -l | awk '{print $1}')
    grep pELS $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.candidates -b stdin > tmp.no1

    
    grep dELS $ccreDir/$dnase*bed | bedtools intersect -wo -a tmp.no1 -b stdin > tmp.dels-links
    awk 'FNR==NR {x[$1$2$3$4];next} !($1$2$3$4 in x)' tmp.dels-links tmp.links | \
        awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.dels-links - | \
        bedtools intersect -wo -b tmp.pls -a stdin > tmp.pls-links

    awk '{print $5 "\t" $6 "\t" $7 "\t" $8}' tmp.dels-links | sort -k1,1 -k2,2n | \
        bedtools closest -d -a stdin -b $tss > tmp.distance
    awk '{if ($NF > '$min') print $4 "\t" $(NF-1)}' tmp.distance | sort -u > tmp.filter


    python test.py ../PLS-Gene-List.hg38-V4.txt tmp.pls-links tmp.dels-links | \
        awk '{print $1 "\t" $4}' | sort -u > x
    awk '{print $5 "\t" $6 "\t" $7 "\t" $8}' tmp.dels-links | sort -k1,1 -k2,2n | \
        bedtools closest -a stdin -b $tss | awk '{print $4 "\t" $NF}' | sort -u | \
        awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.filter - > y
    totalE=$(awk '{print $1}' tmp.filter | sort -u | wc -l | awk '{print $1}')
    awk 'FNR==NR {x[$1$2];next} ($1$2 in x)' x y | awk '{print $1}' | sort -u | \
        wc -l | awk '{print "'$cell'" "\t" $1/'$totalE'*100 "\t" '$totalLinks' "\t" "AllTPM" "\t" "TSS"}'  

    awk '{print $5 "\t" $6 "\t" $7 "\t" $8}' tmp.dels-links | sort -k1,1 -k2,2n | \
        bedtools closest -a stdin -b $genes | awk '{print $4 "\t" $8}' | sort -u | \
        awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.filter - > y
    awk 'FNR==NR {x[$1$2];next} ($1$2 in x)' x y | awk '{print $1}' | sort -u | \
        wc -l | awk '{print "'$cell'" "\t" $1/'$totalE'*100 "\t" '$totalLinks' "\t" "AllTPM" "\t" "GeneBody"}'

    awk '{if ($2 > '$cutoff') print $0}' tmp.rna-quants > tmp.filtered 
    awk '{print $NF "\t" $0}' $tss | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' tmp.filtered - | \
        awk '{print $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8}' > tmp.tss 
    awk '{print $5 "\t" $6 "\t" $7 "\t" $8}' tmp.dels-links | sort -k1,1 -k2,2n | \
        bedtools closest -a stdin -b tmp.tss | awk '{print $4 "\t" $NF}' | sort -u | \
        awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.filter - > y
    awk 'FNR==NR {x[$1$2];next} ($1$2 in x)' x y | awk '{print $1}' | sort -u | \
        wc -l | awk '{print "'$cell'" "\t" $1/'$totalE'*100 "\t" '$totalLinks' "\t" "TPM-Filtered" "\t" "TSS"}'  
    awk '{print $4 "\t" $0}' $genes | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' tmp.filtered - | \
        awk '{print $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9}' > tmp.genes
    awk '{print $5 "\t" $6 "\t" $7 "\t" $8}' tmp.dels-links | sort -k1,1 -k2,2n | \
        bedtools closest -a stdin -b tmp.genes | awk '{print $4 "\t" $8}' | sort -u | \
        awk 'FNR==NR {x[$1];next} ($1 in x)' tmp.filter - > y
    awk 'FNR==NR {x[$1$2];next} ($1$2 in x)' x y | awk '{print $1}' | sort -u | \
        wc -l | awk '{print "'$cell'" "\t" $1/'$totalE'*100 "\t" '$totalLinks' "\t" "TPM-Filtered" "\t" "GeneBody"}'

done
rm tmp* x y
