#!/usr/bin/env python

# -- Kaili
# This script is for calculating CG di-nucleotide with given fasta file.

import re, os, sys
import math
from collections import Counter

##################

if __name__ == "__main__":
    fasta_file = sys.argv[1]
    outfile = sys.argv[2]

    # calculate number of CpG, print
    output = open(outfile, 'w')
    id=""
    for line in open(fasta_file).readlines():
        if line.startswith(">"):
            id=line.rstrip("\n").split(">")[1]
        else:
            num_CG = line.rstrip("\n").upper().count("CG")
            num_C = line.rstrip("\n").upper().count("C")
            num_G = line.rstrip("\n").upper().count("G")
            l=len(line.rstrip("\n"))
            #
            real=num_CG/l
            expected=((num_C/l + num_G/l)/2)**2
            if expected==0:
                content=-1
            else:
                content = round(real/expected,2)
            out = ("\t").join([id, str(content), str(num_CG), str(num_C),str(num_G),str(l)])
            print(out, file=output)

    output.close()
