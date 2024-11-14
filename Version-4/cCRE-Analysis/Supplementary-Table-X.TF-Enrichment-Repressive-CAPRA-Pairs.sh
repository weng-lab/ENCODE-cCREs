
cutoff=$1
awk '{if ($4 > 0 && $2 < '$cutoff' && $5 < $2) print $1}' Summary.5.txt > Rep
awk '{if ($2 > 0 && $4 < '$cutoff' && $5 < $4) print $3}' Summary.5.txt >> Rep
awk '{if ($4 > 0 && $2 < '$cutoff' && $5 < $2) print $3}' Summary.5.txt > NoRep
awk '{if ($2 > 0 && $4 < '$cutoff' && $5 < $4) print $1}' Summary.5.txt >> NoRep

fimo=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/hg38-cCRE.FIMO.txt
awk 'FNR==NR {x[$1];next} ($2 in x)' Rep $fimo > tmp.fimo-rep
awk 'FNR==NR {x[$1];next} ($2 in x)' NoRep $fimo > tmp.fimo-norep


list=/home/moorej3/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Motif/K562-Expressed-Motif.txt
k=$(wc -l $list | awk '{print $1}')
for i in `seq 1 1 $k`
do
    tf=$(awk '{if (NR == '$i') print $1}' $list)
    a=$(grep $tf tmp.fimo-rep | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    b=$(grep $tf tmp.fimo-norep | awk '{print $2}' | sort -u | wc -l | awk '{print $1}')
    awk 'BEGIN{print "'$tf'" "\t" "'$a'" "\t" "'$b'"}'
done > x

a=$(sort -u Rep | wc -l | awk '{print $1}')
b=$(sort -u NoRep | wc -l | awk '{print $1}')

python ~/bin/fisher.test.py x $a $b > xx
awk '{print $4}' xx > p
Rscript ~/bin/padjust.R
paste xx results.txt | grep GFI | awk '{print $0 "\t" "'$a'" "\t" "'$b'"}'
