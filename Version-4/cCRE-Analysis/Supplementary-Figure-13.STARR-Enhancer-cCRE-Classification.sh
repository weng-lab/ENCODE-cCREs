#!/bin/bash

#Jill E Moore
#UMass Chan Medical School
#ENCODE4 cCRE Analysis
#Supplementary Figure 13

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization
scriptDir=~/GitHub/ENCODE-cCREs/Version-4/cCRE-Analysis
tfDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/Individual-TFs
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed

cd $workingDir

ccresK562=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/ENCFF414OGC_ENCFF806YEZ_ENCFF849TDM_ENCFF736UDR.bed
ccresHepG2=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Individual-Files/ENCFF546MZK_ENCFF732PJK_ENCFF795ONN_ENCFF357NFO.bed

grep dELS $ccres > tmp.dels

starr=ENCSR858MPS
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.dels CAPRA-Output/$starr-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $1 "\t" $3}' > tmp.col
starr=ENCSR135NXN
awk 'FNR==NR {x[$4];next} ($1 in x)' tmp.dels CAPRA-Output/$starr-DESeq2.Solo-Filtered.V7.txt | \
    awk '{print $3}' | paste tmp.col - > tmp.matrix

awk '{if ($2 > 0 && $2 > $3+1) print $0}' tmp.matrix > tmp.K562-specific
awk '{if ($3 > 0 && $3 > $2+1) print $0}' tmp.matrix > tmp.HepG2-specific

group=tmp.K562-specific
tf=GATA1
awk 'FNR==NR {x[$2];next} ($1 in x)' $tfDir/$tf"_HUMAN.H11MO"*txt $group > tmp.ccres
awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
    awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresK562 > tmp.k562
awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
    awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresHepG2 > tmp.hepg2
python $scriptDir/Toolkit/count-starr-ccre-groups.py tmp.k562 tmp.hepg2 | \
    awk 'BEGIN{print "class" "\t" "K562" "\t" "HepG2" "\t" "numK562" "\t" "numHepG2" "\t" "group"} \
    {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" "'$tf'"}' > tmp.out

group=tmp.HepG2-specific
tfs=(HNF4A P53 GFI1B)
for tf in ${tfs[@]}
do
    awk 'FNR==NR {x[$2];next} ($1 in x)' $tfDir/$tf"_HUMAN.H11MO"*txt $group > tmp.ccres

    awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
        awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresK562 > tmp.k562
    awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
        awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresHepG2 > tmp.hepg2
    python $scriptDir/Toolkit/count-starr-ccre-groups.py tmp.k562 tmp.hepg2 | \
        awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" "'$tf'"}' >> tmp.out
done

group=tmp.K562-specific
cp $group tmp.ccres
awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
    awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresK562 > tmp.k562
awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
    awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresHepG2 > tmp.hepg2
python $scriptDir/Toolkit/count-starr-ccre-groups.py tmp.k562 tmp.hepg2 | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" "STARR-K562"}' >> tmp.out

group=tmp.HepG2-specific
cp $group tmp.ccres
awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
    awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresK562 > tmp.k562
awk 'FNR==NR {x[$1];next} ($4 in x)' tmp.ccres $ccres | \
    awk 'FNR==NR {x[$5];next} ($4 in x)' - $ccresHepG2 > tmp.hepg2
python $scriptDir/Toolkit/count-starr-ccre-groups.py tmp.k562 tmp.hepg2 | \
    awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" "STARR-HepG2"}' >> tmp.out
mv tmp.out Figure-Input-Data/Supplementary-Figure-13.STARR-Enhancer-cCRE-Classification.txt
rm tmp*
