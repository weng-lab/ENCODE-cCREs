exp=ENCSR661FOW

list=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data/STARR-BAM-List.08-17-2022.Filtered.txt
outputDir=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Fragment-Analysis/$exp

mkdir -p $outputDir
mkdir -p /tmp/JEM
cd /tmp/JEM

rm -f tmp.bed
for i in `seq 50 50 750`
do
    echo $i
    bedtools random -n 50000 -l $i -g ~/Lab/Reference/Human/hg38/chromInfo.txt | awk '{print $1 "\t" $2 "\t" $3 "\t" "random-"NR"-'$i'"}' >> tmp.bed
done

ccre=tmp.bed

dna=$(awk -F "\t" '{if ($1 == "'$exp'") print $8}' $list | \
	awk -F ";" '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf " %s", $i; print ""}')

rna=$(awk -F "\t" '{if ($1 == "'$exp'") print $7}'  $list | awk -F ";" '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf " %s", $i; print ""}')

sort -k4,4 $ccre | awk 'BEGIN{print "rdhs"}{print $4}' > tmp.matrix
echo $dna
echo $rna
for d in ${dna[@]}
do
	echo $d
    dnaBed=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data/$exp/$d.bed
    bedtools intersect -c -a $dnaBed -b $ccre > tmp.1
    awk '{if ($NF > 0) print $0}' tmp.1 > tmp.2
    bedtools intersect -f 1 -c -a $ccre -b tmp.2 > tmp.col
    sort -k4,4 tmp.col | awk 'BEGIN{print "DNA"}{print $NF}' | paste tmp.matrix - > tmp.tmp
    mv tmp.tmp tmp.matrix
done

for r in ${rna[@]}
do
	echo $r
    rnaBed=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/Data/$exp/$r.bed
    bedtools intersect -c -a $rnaBed -b $ccre > tmp.1
    awk '{if ($NF > 0) print $0}' tmp.1 > tmp.2
    bedtools intersect -f 1 -c -a $ccre -b tmp.2 > tmp.col
    sort -k4,4 tmp.col | awk 'BEGIN{print "RNA"}{print $NF}' | paste tmp.matrix - > tmp.tmp
    mv tmp.tmp tmp.matrix
done

mv tmp.matrix $outputDir/Fragment-Length-Test.$exp-Matrix.Solo.V7.txt
rm tmp.*

cd
rm -r /tmp/JEM

