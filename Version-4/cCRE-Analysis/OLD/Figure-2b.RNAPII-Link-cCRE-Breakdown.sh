
cd ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/3D-Links

list=Paired-Biosample-List.txt
ccreDir=../Cell-Type-Specific/Individual-Files
chiapetDir=/data/projects/encode/3D-Chromatin/ChIA-PET/Ruan-ENCODE4/
dataDir=/data/projects/encode/data/

for i in `seq 1 1 9`
do
    cell=$(awk '{if (NR == '$i') print $1}' $list | awk -F "_" '{print $3}')
    dnase=$(awk '{if (NR == '$i') print $9}' $list)
    grep PLS $ccreDir/$dnase*bed > tmp.pls

    rnap2=$(awk '{if (NR == '$i') print $2}' $list)
    ctcf=$(awk '{if (NR == '$i') print $4}' $list)

    links=$chiapetDir/$rnap2.DAC-Links.V2.bedpe

    awk '{print $1 "\t" $2 "\t" $3 "\t" "id-"NR "\n" $4 "\t" $5 "\t" $6 "\t" "id-"NR}' $links > tmp.links
    bedtools intersect -c -a tmp.pls -b tmp.links > tmp.overlaptot

    cat tmp.overlaptot | bedtools intersect -u -b stdin -a tmp.links > tmp.overlap
    totLinks=$(wc -l $links | awk '{print $1}')
    totPLS=$(awk '{print $4}' tmp.overlap | sort -u | wc -l | awk '{print $1}')
    python ../count.py tmp.overlap -1 > tmp.count
    awk '{if ($NF > 1) print $0}' tmp.count > tmp.multiple
    awk '{if ($NF == 1) print $0}' tmp.count > tmp.1
    awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.1 tmp.links | \
        awk 'FNR==NR {x[$1$2$3];next} !($1$2$3 in x)' tmp.overlap - > tmp.candidates

    plsCount=$(wc -l tmp.multiple | awk '{print $1}')
    pelsCount=$(grep pELS $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.candidates -b stdin | wc -l | awk '{print $1}')
    grep pELS $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.candidates -b stdin > tmp.no1
    delsCount=$(grep dELS $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.no1 -b stdin | wc -l | awk '{print $1}')
    grep dELS $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.no1 -b stdin > tmp.no2
    k4Count=$(grep CA-H3K4me3 $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.no2 -b stdin | wc -l | awk '{print $1}')
    grep CA-H3K4me3 $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.no2 -b stdin > tmp.no1
    ctctCount=$(grep CA-CTCF $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.no1 -b stdin | wc -l | awk '{print $1}')
    grep CA-CTCF $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.no1 -b stdin > tmp.no2
    tfCount=$(grep CA-TF $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.no2 -b stdin | wc -l | awk '{print $1}')
    grep CA-TF $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.no2 -b stdin > tmp.no1
    caCount=$(grep CA-only $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.no1 -b stdin | wc -l | awk '{print $1}')
    grep CA-only $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.no1 -b stdin > tmp.no2
    lowCount=$(grep Low-DNase $ccreDir/$dnase*bed | bedtools intersect -u -a tmp.no2 -b stdin | wc -l | awk '{print $1}')
    grep Low-DNase $ccreDir/$dnase*bed | bedtools intersect -v -a tmp.no2 -b stdin > tmp.no1
    noneCount=$(bedtools intersect -v -a tmp.no1 -b $ccreDir/$dnase*bed | wc -l | awk '{print $1}')

    echo -e $cell "\t" $totLinks "\t" $totPLS "\t" $plsCount "\t" $pelsCount "\t" $delsCount "\t" $k4Count "\t" \
        $ctctCount "\t" $tfCount "\t" $caCount "\t" $lowCount "\t" $noneCount
done
