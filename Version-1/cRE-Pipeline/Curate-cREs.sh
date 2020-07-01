source ~/.bashrc

rdhs=$1
genome=$2

awk 'FNR==NR {x[$1];next} ($4 in x)' ctcf-like $rdhs | \
    awk '{print $0 "\t" "CTCF-only"}' > cres.bed

awk 'FNR==NR {x[$1];next} ($4 in x)' enhancer-like $rdhs | \
    awk '{print $0 "\t" "Enhancer-like"}' >> cres.bed

awk 'FNR==NR {x[$1];next} ($4 in x)' promoter-like $rdhs | \
    awk '{print $0 "\t" "Promoter-like"}' >> cres.bed

python /home/jm36w/scratch/Test/accession-cres.py cres.bed $genome

