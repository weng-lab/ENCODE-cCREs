#!/usr/bin/env python2

#SPDX-License-Identifier: MIT
#Copyright (c) 2016-2020 Jill Moore, Michael Purcaro, Henry Pratt, Zhiping Weng

#Step 6 of ENCODE cCRE pipeline (V2)
#Jill E. Moore
#Weng Lab

#Script that summarizes cCRE tiers
#Executed by Extract-Class.sh

import sys

d={}
f=open(sys.argv[1])
for line in f:
    line=line.rstrip().split("\t")
    if line[0] not in d:
	d[line[0]]=[[line[1]],[]]
    elif line[1] not in d[line[0]][0]:
	d[line[0]][0].append(line[1])
f.close()

f=open(sys.argv[2])
for line in f:
    line=line.rstrip().split("\t")
    if line[0] not in d:
        d[line[0]]=[[],[line[1]]]
    elif line[1] not in d[line[0]][1]:
        d[line[0]][1].append(line[1])
f.close()

for entry in d:
    try:
	print entry+"\t"+".".join(sorted(d[entry][0]))+"\t"+".".join(sorted(d[entry][1]))
    except:
	print entry, "\t", sorted(d[entry][0]), "\t", sorted(d[entry][1])
	
