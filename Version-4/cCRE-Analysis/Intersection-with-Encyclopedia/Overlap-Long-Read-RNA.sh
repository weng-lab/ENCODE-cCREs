

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/S3_Encyclopedia_Overlap/PacBio

cd $workingDir

genome=hg38

scriptDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/TSS/PacBio-TSS
outputDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/TSS/PacBio-TSS/
list=Long-RNA-List.hg38.09-19-2022.txt

total=$(wc -l $list | awk '{print $1}')
for j in `seq 1 1 $total`
do
	exp=$(awk '{if (NR == '$j') print $1}' $list)
    if [ ! -f $exp.TSS.bed ]
    then
	   bams=$(awk -F "\t" '{if (NR == '$j') print $2}'  $list | awk -F ";" '{printf "%s", $1; for(i=2;i<=NF;i+=1) printf " %s", $i; print ""}')
	   for bam in ${bams[@]}
	   do
	      echo $accession
	      if [ ! -f $bam.bam ]
	      then
	         wget https://www.encodeproject.org/files/$bam/@@download/$bam.bam
	      fi  
	      samtools sort -@ 16 $bam.bam -o $bam.tmp.bam
	   done
	   echo "Merging bams ..."
	   samtools merge -@ 16 merge.bam *.tmp.bam
	
       echo "Sorting and indexing bam ..."
       samtools sort merge.bam -o $exp-Merge.bam
       samtools index $exp-Merge.bam
	
       echo "Separating strands ..."
       samtools view -b -F 16 $exp-Merge.bam -o pos.bam
       samtools view -b -f 16 $exp-Merge.bam -o neg.bam
	
       echo "Extracting 5'ends ..."
       bedtools bamtobed -i pos.bam | awk '{print $1 "\t" $2 "\t" $2+1 "\t" $4}' | sort -k1,1 -k2,2n > p.bed
       bedtools bamtobed -i neg.bam | awk '{print $1 "\t" $3-1 "\t" $3 "\t" $4}' | sort -k1,1 -k2,2n > n.bed

       total=$(wc -l p.bed n.bed | awk '{if (NR == 3) print $1}')

       bedtools merge -d 25 -c 1 -o count -i p.bed > tmp
       bedtools merge -d 25 -c 1 -o count -i n.bed >> tmp
       sort -k1,1 -k2,2n tmp | awk '{print $1 "\t" $2 "\t" $3 "\t" "TSS-"NR "\t" $4 "\t" $4/'$total'*1000000}' > $exp.TSS.bed
       rm tmp* *bam p.bed n.bed
    fi 
    awk '{if ($1 ~ /chr/) print $0}' $exp.TSS.bed | sort -k1,1 -k2,2n > tmp.bed
    mv tmp.bed $exp.TSS.bed
    total=$(awk '{if ($6 > 5) print $0}' $exp.TSS.bed | wc -l | awk '{print $1}')
    awk '{printf "%s\t%.0f\t%.0f\t%s\n", $1,($3+$2)/2,($3+$2)/2,$4}' \
        ../../../hg38-cCREs-Unfiltered.bed ../../../hg38-rDHS/hg38-Multimappers.bed | sort -k1,1 -k2,2n | \
        bedtools closest -d -a $exp.TSS.bed -b stdin | \
        awk '{if ($NF < 200 && $6 > 5) print $4}' | sort -u | wc -l | \
        awk '{print "'$exp'" "\t" $1 "\t" '$total' "\t" $1/'$total'*100}'
done
