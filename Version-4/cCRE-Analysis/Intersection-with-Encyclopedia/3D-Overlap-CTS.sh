list=Three-Assay-Matched-List.txt
ccreDir=../Cell-Type-Specific/Individual-Files
chiapetDir=/data/projects/encode/3D-Chromatin/ChIA-PET/Ruan-ENCODE4/
dataDir=/data/projects/encode/data/

for i in `seq 1 1 6`
do
    cell=$(awk '{if (NR == '$i') print $1}' $list | awk -F "_" '{print $3}')
    dnase=$(awk '{if (NR == '$i') print $9}' $list)

    rnap2=$(awk '{if (NR == '$i') print $2}' $list)
    ctcf=$(awk '{if (NR == '$i') print $4}' $list)
    hic1=$(awk '{if (NR == '$i') print $18}' $list)
    hic2=$(awk '{if (NR == '$i') print $20}' $list)

    links=$chiapetDir/$rnap2.DAC-Links.V2.bedpe
    awk '{if ($1 == $4) print $1 "\t" $2 "\t" $3 "\t" "Link-"NR}' $links > tmp.1
    awk '{if ($1 == $4) print $4 "\t" $5 "\t" $6 "\t" "Link-"NR}' $links > tmp.2

    total=$(wc -l tmp.1 | awk '{print $1}')

    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.1 > tmp.1-intersect
    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.2 > tmp.2-intersect
    oneAll=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothAll=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    oneCTS=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothCTS=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    pls=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    
    awk 'BEGIN {print "'$cell'" "\t" "RNAPII" "\t" '$total' "\t" '$oneAll' "\t" '$bothAll' "\t" '$oneCTS' "\t" '$bothCTS' "\t" '$pls'}'

    links=$chiapetDir/$ctcf.DAC-Links.V2.bedpe
    awk '{if ($1 == $4) print $1 "\t" $2 "\t" $3 "\t" "Link-"NR}' $links > tmp.1
    awk '{if ($1 == $4) print $4 "\t" $5 "\t" $6 "\t" "Link-"NR}' $links > tmp.2

    total=$(wc -l tmp.1 | awk '{print $1}')

    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.1 > tmp.1-intersect
    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.2 > tmp.2-intersect
    oneAll=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothAll=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    oneCTS=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothCTS=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    pls=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    
    awk 'BEGIN {print "'$cell'" "\t" "CTCF" "\t" '$total' "\t" '$oneAll' "\t" '$bothAll' "\t" '$oneCTS' "\t" '$bothCTS' "\t" '$pls'}'

    links=New-HiC/$hic1*.bedpe
    awk '{if ($1 == $4) print $1 "\t" $2 "\t" $3 "\t" "Link-"NR}' $links > tmp.1
    awk '{if ($1 == $4) print $4 "\t" $5 "\t" $6 "\t" "Link-"NR}' $links > tmp.2

    total=$(wc -l tmp.1 | awk '{print $1}')

    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.1 > tmp.1-intersect
    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.2 > tmp.2-intersect
    oneAll=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothAll=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    oneCTS=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothCTS=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    pls=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    
    awk 'BEGIN {print "'$cell'" "\t" "New-HiC" "\t" '$total' "\t" '$oneAll' "\t" '$bothAll' "\t" '$oneCTS' "\t" '$bothCTS' "\t" '$pls'}'

    links=HiC/$hic2*.bedpe
    awk '{if ($1 == $4) print $1 "\t" $2 "\t" $3 "\t" "Link-"NR}' $links > tmp.1
    awk '{if ($1 == $4) print $4 "\t" $5 "\t" $6 "\t" "Link-"NR}' $links > tmp.2

    total=$(wc -l tmp.1 | awk '{print $1}')

    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.1 > tmp.1-intersect
    bedtools intersect -u -b $ccreDir/$dnase*bed -a tmp.2 > tmp.2-intersect
    oneAll=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothAll=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep -v Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    oneCTS=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    bothCTS=$(awk 'FNR==NR {x[$4];next} ($4 in x)' tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')

    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.1 > tmp.1-intersect
    grep PLS $ccreDir/$dnase*bed | bedtools intersect -u -b stdin -a tmp.2 > tmp.2-intersect
    pls=$(cat tmp.1-intersect tmp.2-intersect | awk '{print $4}' | sort -u | wc -l | awk '{print $1}')
    
    awk 'BEGIN {print "'$cell'" "\t" "Portal-HiC" "\t" '$total' "\t" '$oneAll' "\t" '$bothAll' "\t" '$oneCTS' "\t" '$bothCTS' "\t" '$pls'}'
    
done
