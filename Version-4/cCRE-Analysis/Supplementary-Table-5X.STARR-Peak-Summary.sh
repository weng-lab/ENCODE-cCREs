source ~/.bashrc

list=White-STARR-Peak-List.txt
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/hg38-cCREs-Unfiltered.bed
dataDir=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data
workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/2_Functional-Characterization

cd $workingDir
rm -r tmp.results
k=$(wc -l $list | awk '{print $1}')

for i in `seq 1 1 $k`
do
    bed=$(awk -F "\t" '{if (NR == "'$i'") print $2}' $list)
    cell=$(awk -F "\t" '{if (NR == "'$i'") print $4}' $list)
    dnase=$(grep $cell"_ENCD" ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Cell-Type-Specific/Master-Cell-List.txt | awk '{print $2}')

    wget https://www.encodeproject.org/files/$bed/@@download/$bed.bed.gz
    gunzip $bed.bed.gz

    numPeaks=$(wc -l $bed.bed | awk '{print $1}')
    aveSize=$(awk '{sum += $3-$2}END{print sum/NR}' $bed.bed)
    medSize=$(awk '{print $3-$2}' $bed.bed | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
    overlap=$(bedtools intersect -u -a $bed.bed -b $ccres | wc -l | awk '{print $1}')
    echo -e $bed "\t" $numPeaks "\t" $aveSize "\t" $medSize "\t" $overlap >> tmp.results

    bedtools intersect -u -a $bed.bed -b $ccres > tmp.yes
    bedtools intersect -v -a $bed.bed -b $ccres > tmp.no

    bedtools intersect -u -a tmp.yes -b All-MPRA.txt | bedtools intersect -u -a stdin -b All-MPRA-Pos.txt | awk '{if ($NF >0) sum += 1}END{print "Yes" "\t" sum "\t" sum/NR}' >> tmp.func
    bedtools intersect -u -a tmp.no -b All-MPRA.txt | bedtools intersect -u -a stdin -b All-MPRA-Pos.txt | awk '{if ($NF >0) sum += 1}END{print "No" "\t" sum "\t" sum/NR}' >> tmp.func

    ~/bin

    rm $bed.bed
done

wget https://www.encodeproject.org/files/ENCFF454ZKK/@@download/ENCFF454ZKK.bed.gz
wget https://www.encodeproject.org/files/ENCFF919UHO/@@download/ENCFF919UHO.bed.gz
wget https://www.encodeproject.org/files/ENCFF549QUG/@@download/ENCFF549QUG.bed.gz

gunzip *bed.gz

awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' ENCFF454ZKK.bed > ENCFF454ZKK.mod.bed
awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' ENCFF919UHO.bed > ENCFF919UHO.mod.bed
awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' ENCFF549QUG.bed > ENCFF549QUG.mod.bed

bedtools intersect -a ENCFF454ZKK.mod.bed -b ENCFF549QUG.mod.bed | bedtools intersect -a stdin -b ENCFF919UHO.mod.bed > tmp.common

numPeaks=$(wc -l tmp.common | awk '{print $1}')
aveSize=$(awk '{sum += $3-$2}END{print sum/NR}' tmp.common)
medSize=$(awk '{print $3-$2}' tmp.common | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }')
overlap=$(bedtools intersect -u -a $bed.bed -b $ccres | wc -l | awk '{print $1}')
echo -e "ENCSR661FOW-peaks" "\t" $numPeaks "\t" $aveSize "\t" $medSize "\t" $overlap >> tmp.results
rm -f ENCFF*bed
