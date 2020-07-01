#!/bin/bash 

#Jill E. Moore - Jill.Elizabeth.Moore@gmail.com
#Weng Lab - UMass Medical School
#ENCODE Encyclopedia Version 4
#Updated June 2017

module load bedtools/2.25.0

rdhs=$1

dnaseMax=$2
h3k4me3Max=$3
h3k27acMax=$4
ctcfMax=$5

TSS=$6

awk '{if ($2 > 1.64) print $0}' $dnaseMax > list
awk 'FNR==NR {x[$1];next} ($4 in x)' list $rdhs > bed
bedtools intersect -u -a bed -b $TSS > proximal
bedtools intersect -v -a bed -b $TSS > distal

awk 'FNR==NR {x[$4];next} ($1 in x)' proximal $h3k4me3Max | \
    awk '{if ($2 > 1.64) print $0}' > H3K4me3-proximal
awk 'FNR==NR {x[$4];next} ($1 in x)' distal $h3k27acMax | \
    awk '{if ($2 > 1.64) print $0}' > H3K27ac-distal

awk 'FNR==NR {x[$4];next} ($1 in x)' proximal $h3k4me3Max | \
    awk '{if ($2 < 1.64) print $0}' > no1
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $h3k27acMax | \
    awk '{if ($2 > 1.64) print $0}' > H3K27ac-proximal
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $h3k27acMax | \
    awk '{if ($2 < 1.64) print $0}' > no

awk 'FNR==NR {x[$4];next} ($1 in x)' distal $h3k27acMax | \
    awk '{if ($2 < 1.64) print $0}' > no1
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $h3k4me3Max | \
    awk '{if ($2 > 1.64) print $0}' > H3K4me3-distal
awk 'FNR==NR {x[$1];next} ($1 in x)' no1 $h3k4me3Max | \
    awk '{if ($2 < 1.64) print $0}' >> no

awk 'FNR==NR {x[$1];next} ($1 in x)' no $ctcfMax | \
    awk '{if ($2 > 1.64) print $0}' > ctcf-like
awk 'FNR==NR {x[$1];next} ($1 in x)' no $ctcfMax | \
    awk '{if ($2 < 1.64) print $0}' > no2

awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $dnaseMax | \
    awk '{if ($2 > 1.64) print $0}' > dnase-like
awk 'FNR==NR {x[$1];next} ($1 in x)' no2 $dnaseMax | \
    awk '{if ($2 < 1.64) print $0}' > none

cat H3K4me3-proximal H3K4me3-distal > promoter-like
cat H3K27ac-distal H3K27ac-proximal > enhancer-like



