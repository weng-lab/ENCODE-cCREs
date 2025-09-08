import numpy as np
import pandas as pd
import os
import glob
from pyfaidx import Fasta

def get_rc(re):
    """
    Return the reverse complement of a DNA/RNA RE.
    """
    return re.translate(str.maketrans('ACGTURYKMBVDHSWN', 'TGCAAYRMKVBHDSWN'))[::-1]


codon_df = pd.read_csv("codon_table.csv")
codon_df["Codon"] = codon_df["Codon"].str.replace("U", "T")
codon_dict = dict(zip(codon_df["Codon"], codon_df["AA.Abv"]))

with open('klf.maf') as f, open('klf-241mammals-aa.txt', 'w') as out:
    for line in f:
        split = line.strip().split("\t")
        if split[0] == 's':
            species = split[1].split(".")[0]
            codon = get_rc(split[-1].upper())
            if 'N' in codon:
                amino_acid = "Unknown"
            else:
                amino_acid = codon_dict[codon]
            print(species, codon, amino_acid, codon[0], codon[1], codon[2], file=out, sep="\t")