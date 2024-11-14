workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/1_Updated-Registry/Multimappers
cd $workingDir

genes=~/Lab/Reference/Human/hg38/GENCODE40/Genes.Basic.bed
mapped=../../../PLS-Gene-List.hg38-V4.txt
rm -f tmp.results
groups=(protein_coding lncRNA)
for group in ${groups[@]}
do

    total=$(awk '{if ($NF == "'$group'") print $4}' $genes | wc -l | awk '{print $1}')
    awk '{if ($NF == "'$group'") print $4}' $genes | \
        awk 'FNR==NR {x[$2];next} ($1 in x)' $mapped - | \
        wc -l | awk '{print "'$group'" "\t" "unique-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}' >> tmp.results

    total=$(awk '{if ($NF == "'$group'") print $4}' $genes | wc -l | awk '{print $1}')
    awk '{if ($NF == "'$group'") print $4}' $genes | \
        awk 'FNR==NR {x[$1];next} ($1 in x)' added-genes - | \
        wc -l | awk '{print "'$group'" "\t" "multi-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}' >> tmp.results
done

total=$(awk '{if ($NF != "lncRNA" && $NF != "protein_coding") print $4}' $genes | wc -l | awk '{print $1}')
awk '{if ($NF != "lncRNA" && $NF != "protein_coding") print $4}' $genes | \
    awk 'FNR==NR {x[$2];next} ($1 in x)' $mapped - | \
    wc -l | awk '{print "other" "\t" "unique-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}' >> tmp.results  

total=$(awk '{if ($NF != "lncRNA" && $NF != "protein_coding") print $4}' $genes | wc -l | awk '{print $1}')
awk '{if ($NF != "lncRNA" && $NF != "protein_coding") print $4}' $genes | \
    awk 'FNR==NR {x[$1];next} ($1 in x)' added-genes - | \
    wc -l | awk '{print "other" "\t" "multi-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}' >> tmp.results   


total=$(wc -l Whole-Genome.txt | awk '{print $1}')
awk '{print $2}' $mapped | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' - Whole-Genome.txt | \
    wc -l | awk '{print "whole-genome" "\t" "unique-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}' >> tmp.results
awk '{print $1}' added-genes | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' - Whole-Genome.txt | \
    wc -l | awk '{print "whole-genome" "\t" "multi-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}'  >> tmp.results

total=$(wc -l Small-Scale.txt | awk '{print $1}')
awk '{print $2}' $mapped | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' - Small-Scale.txt | \
    wc -l | awk '{print "small-scale" "\t" "unique-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}' >> tmp.results
awk '{print $1}' added-genes | awk -F "." 'FNR==NR {x[$1];next} ($1 in x)' - Small-Scale.txt | \
    wc -l | awk '{print "small-scale" "\t" "multi-map" "\t" $1 "\t" "'$total'" "\t" $1/'$total'*100}' >> tmp.results

tail -n 4 tmp.results > tmp.mini

echo -e "group" "\t" "whole-genome" "\t" "small-scale" > tmp.results2
grep "unique-map" tmp.mini | awk '{print $4}' | tr '\n' '\t' | awk '{print "background" "\t" $0}' >> tmp.results2
grep "unique-map" tmp.mini | awk '{print $3}' | tr '\n' '\t' | awk '{print "unique-map" "\t" $0}' >> tmp.results2
grep "multi-map" tmp.mini | awk '{print $3}' | tr '\n' '\t' | awk '{print "multi-map" "\t" $0}' >> tmp.results2

mv tmp.results ../Figure-Input-Data/Supplementary-Figure-2a.Promoter-Coverage.txt
mv tmp.results2 ../Figure-Input-Data/Supplementary-Figure-2b.Duplication-MultiMap.txt

rm tmp.*
