#Jill Moore
#Moore Lab - UMass Chan
#July 2024

#Usage:

source ~/.bashrc

workingDir=~/Lab/ENCODE/Encyclopedia/V7/Registry/V7-hg38/Manuscript-Analysis/3_Silencers
vista=~/Lab/ENCODE/Encyclopedia/V7/Functional-Characterization/VISTA/VISTA-hg38.04-22-2023.bed

cd $workingDir

rm -f tmp.results
classes=(dELS CA-TF)
for class in ${classes[@]}
do
    awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | \
        bedtools intersect -u -a $vista -b stdin | \
        awk 'BEGIN{sum=0}{if ($5 == "positive") sum += 1} \
        END{print "'$class'\tREST+" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR}' >> tmp.results
    awk '{if ($NF == "'$class'") print $0}' REST-cCREs.All.bed | \
        awk 'FNR==NR {x[$4];next} !($4 in x)' - ../../hg38-cCREs-Unfiltered.bed | \
        awk '{if ($NF == "'$class'") print $0}' - | \
            bedtools intersect -u -a $vista -b stdin | \
            awk 'BEGIN{sum=0}{if ($5 == "positive") sum += 1} \
	    END{print "'$class'\tREST-" "\t" sum "\t" sum/NR "\t" NR-sum "\t" (NR-sum)/NR}' >> tmp.results
done

mv tmp.results Figure-Input-Data/Figure-3f.REST-Silencer-VISTA.txt
