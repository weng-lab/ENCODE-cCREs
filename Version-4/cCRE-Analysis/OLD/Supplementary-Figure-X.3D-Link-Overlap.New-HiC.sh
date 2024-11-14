cd ~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/3D-Links

list=3D-Data-Matrix.New-HiC.txt

for j in `seq 2 1 11`
do

rnap=$(awk -F "\t" '{if (NR == '$j') print $2}' $list)
ctcf=$(awk -F "\t" '{if (NR == '$j') print $3}' $list)
hic=$(awk -F "\t" '{if (NR == '$j') print $4}' $list)
cell=$(awk -F "\t" '{if (NR == '$j') print $1}' $list)

chiaDir=/data/projects/encode/3D-Chromatin/ChIA-PET/Ruan-ENCODE4
hicDir=/home/moorej3/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/3D-Links/New-HiC

rnapBedPE=$chiaDir/$rnap.DAC-Links.V2.bedpe
ctcfBedPE=$chiaDir/$ctcf.DAC-Links.V2.bedpe

#python ~/scratch/quick-encode-pull.py $hic bedpe.gz $hicDir
hicBedPE=$hicDir/$hic.attributes_anchorAPA_pass.bed_sieveML_only_good.bedpe
#gunzip $hicBedPE.gz

rnapCount=$(wc -l $rnapBedPE | awk '{print $1}')
ctcfCount=$(wc -l $ctcfBedPE | awk '{print $1}')
hicCount=$(wc -l $hicBedPE | awk '{print $1}')

#echo -e $cell "\t" $rnapCount "\t" $ctcfCount "\t" $hicCount

awk '{print $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11}' $rnapBedPE > tmp.rnap
awk '{print $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11}' $ctcfBedPE > tmp.ctcf
awk '{if (NR >2) print $4 "\t" $5 "\t" $6 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15}' $hicBedPE > tmp.hic

bedtools intersect -u -a $rnapBedPE -b $ctcfBedPE > tmp.1
bedtools intersect -u -a tmp.rnap -b tmp.ctcf > tmp.2
rnap_ctcf=$(awk 'FNR==NR {x[$4$5$6$7$8$9$10$11];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

bedtools intersect -u -a $rnapBedPE -b $hicBedPE > tmp.1
bedtools intersect -u -a tmp.rnap -b tmp.hic > tmp.2
rnap_hic=$(awk 'FNR==NR {x[$4$5$6$7$8$9$10$11];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

bedtools intersect -u -a $rnapBedPE -b $ctcfBedPE | bedtools intersect -u -a stdin -b $hicBedPE > tmp.1
bedtools intersect -u -a tmp.rnap -b tmp.ctcf | bedtools intersect -u -a stdin -b tmp.hic > tmp.2
rnap_both=$(awk 'FNR==NR {x[$4$5$6$7$8$9$10$11];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

#echo -e "\t" $rnapCount "\t" $rnap_ctcf "\t" $rnap_hic "\t" $rnap_both

bedtools intersect -u -a $ctcfBedPE -b $rnapBedPE > tmp.1
bedtools intersect -u -a tmp.ctcf -b tmp.rnap > tmp.2
ctcf_rnap=$(awk 'FNR==NR {x[$4$5$6$7$8$9$10$11];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

bedtools intersect -u -a $ctcfBedPE -b $hicBedPE > tmp.1
bedtools intersect -u -a tmp.ctcf -b tmp.hic > tmp.2
ctcf_hic=$(awk 'FNR==NR {x[$4$5$6$7$8$9$10$11];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

bedtools intersect -u -b $rnapBedPE -a $ctcfBedPE | bedtools intersect -u -a stdin -b $hicBedPE > tmp.1
bedtools intersect -u -b tmp.rnap -a tmp.ctcf | bedtools intersect -u -a stdin -b tmp.hic > tmp.2
ctcf_both=$(awk 'FNR==NR {x[$4$5$6$7$8$9$10$11];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

#echo -e "\t" $ctcf_rnap "\t" $ctcfCount "\t" $ctcf_hic "\t" $ctcf_both

bedtools intersect -u -a $hicBedPE -b $rnapBedPE > tmp.1
bedtools intersect -u -a tmp.hic -b tmp.rnap > tmp.2
hic_rnap=$(awk 'FNR==NR {x[$4$5$6$11$12$13$14$15];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

bedtools intersect -u -b $ctcfBedPE -a $hicBedPE > tmp.1
bedtools intersect -u -b tmp.ctcf -a tmp.hic > tmp.2
hic_ctcf=$(awk 'FNR==NR {x[$4$5$6$11$12$13$14$15];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

bedtools intersect -u -a $hicBedPE -b $rnapBedPE | bedtools intersect -u -a stdin -b $ctcfBedPE > tmp.1
bedtools intersect -u -a tmp.hic -b tmp.rnap | bedtools intersect -u -a stdin -b tmp.ctcf > tmp.2
hic_both=$(awk 'FNR==NR {x[$4$5$6$11$12$13$14$15];next} ($1$2$3$4$5$6$7$8 in x)' tmp.1 tmp.2 | wc -l | awk '{print $1}')

#echo -e "\t" $hic_rnap "\t" $hic_ctcf "\t" $hicCount "\t" $hic_both

#echo -e "\n" "\n"

awk 'BEGIN{print "'$cell'" "\t" ('$rnapCount'-(('$rnap_ctcf'-'$rnap_both')+('$rnap_hic'-'$rnap_both')+'$rnap_both'))/'$rnapCount'*100 "\t" ('$rnap_ctcf'-'$rnap_both')/'$rnapCount'*100 "\t" ('$rnap_hic'-'$rnap_both')/'$rnapCount'*100 "\t" '$rnap_both'/'$rnapCount'*100 "\t" ('$ctcf_rnap'-'$ctcf_both')/'$ctcfCount'*100 "\t" ('$ctcfCount'-(('$ctcf_hic'-'$ctcf_both')+('$ctcf_rnap'-'$ctcf_both')+'$ctcf_both'))/'$ctcfCount'*100 "\t" ('$ctcf_hic'-'$ctcf_both')/'$ctcfCount'*100 "\t" '$ctcf_both'/'$ctcfCount'*100 "\t" ('$hic_rnap'-'$hic_both')/'$hicCount'*100 "\t" ('$hic_ctcf'-'$hic_both')/'$hicCount'*100 "\t" ('$hicCount'-(('$hic_rnap'-'$hic_both')+('$hic_ctcf'-'$hic_both')+'$hic_both'))/'$hicCount'*100 "\t" '$hic_both'/'$hicCount'*100}'

rm tmp.*
done
