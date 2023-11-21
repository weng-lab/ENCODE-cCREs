#Jill Moore
#Moore Lab - UMass Chan
#November 2023

#Usage:
#./Figure-1c.Estimate-Mouse-Enhancers.sh

dir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-mm10/Cell-Type-Specific
list1=$dir/Manual-Master-Cell-List.txt
list2=$dir/Master-Cell-List.txt
ccres=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-mm10/mm10-cCREs-Unfiltered.bed

rm -f tmp.*

awk '{if ($1 != "---" && $5 != "---") print $0}' $list1 > tmp.list
k=$(wc -l tmp.list | awk '{print $1}')
for j in `seq 1 1 $k`
do
    echo $j
    data=$(awk '{if (NR=="'$j'") print $2}' tmp.list)
    awk '{if ($10 == "CA-only") print $0}' $dir/Manual-Match-Files/$data*.bed >> tmp.CA 
done

awk '{if ($1 != "---" && $5 != "---") print $0}' $list2 > tmp.list
k=$(wc -l tmp.list | awk '{print $1}')
for j in `seq 1 1 $k`
do
    echo $j
    data=$(awk '{if (NR=="'$j'") print $2}' tmp.list)
    awk '{if ($10 == "CA-only") print $0}' $dir/Individual-Files/$data*.bed >> tmp.CA 
done

totalCA=$(awk '{if ($6 == "CA") sum += 1}END{print sum}' $ccres)
awk '{print $4}' tmp.CA | sort -u | \
    awk 'FNR==NR {x[$1];next} ($5 in x)' - $ccres | \
    awk '{if ($6 == "CA") sum += 1}\
    END{print "Total CA: " '$totalCA' "\nPossible ELS: "'$totalCA'-sum}'

rm -f tmp.*
