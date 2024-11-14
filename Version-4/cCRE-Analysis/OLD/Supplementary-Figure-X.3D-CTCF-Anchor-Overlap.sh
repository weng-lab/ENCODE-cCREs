cd ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/3D-Links

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
    chip=$(awk '{if (NR == '$i') print $14"-"$15}' $list)

    awk '{if ($2 > 1.64) print $1}' ../signal-output/$chip.txt | \
        awk 'FNR==NR {x[$1];next} ($4 in x)' - ../hg38-cCREs-Unfiltered.bed > tmp.ctcf

    links=$chiapetDir/$rnap2.DAC-Links.V2.bedpe
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" "id-"NR}' $links > tmp.links
    total=$(wc -l tmp.links | awk '{print $1}')
    both=$(bedtools pairtobed -type both -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    either=$(bedtools pairtobed -type either -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    neither=$(bedtools pairtobed -type neither -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    echo -e $cell "\t" "RNAPII" "\t" $total "\t" $both "\t" $either "\t" $neither


    links=$chiapetDir/$ctcf.DAC-Links.V2.bedpe
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" "id-"NR}' $links > tmp.links
    total=$(wc -l tmp.links | awk '{print $1}')
    both=$(bedtools pairtobed -type both -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    either=$(bedtools pairtobed -type either -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    neither=$(bedtools pairtobed -type neither -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    echo -e $cell "\t" "CTCF" "\t" $total "\t" $both "\t" $either "\t" $neither


    links=New-HiC/$hic1*.bedpe
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" "id-"NR}' $links > tmp.links
    total=$(wc -l tmp.links | awk '{print $1}')
    both=$(bedtools pairtobed -type both -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    either=$(bedtools pairtobed -type either -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    neither=$(bedtools pairtobed -type neither -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    echo -e $cell "\t" "New-HiC" "\t" $total "\t" $both "\t" $either "\t" $neither

    links=HiC/$hic2*.bedpe
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" "id-"NR}' $links > tmp.links
    total=$(wc -l tmp.links | awk '{print $1}')
    both=$(bedtools pairtobed -type both -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    either=$(bedtools pairtobed -type either -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    neither=$(bedtools pairtobed -type neither -a tmp.links -b tmp.ctcf | awk '{print $7}' | sort -u | wc -l | awk '{print $1}')
    echo -e $cell "\t" "Portal-HiC" "\t" $total "\t" $both "\t" $either "\t" $neither 
done
