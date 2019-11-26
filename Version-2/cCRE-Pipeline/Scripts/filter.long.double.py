import sys
from decimal import Decimal

enrichment=open(sys.argv[1])
threshold=int(sys.argv[2].split("E-")[1])


for line in enrichment:
    fdr=str(line.rstrip().split("\t")[4])
    if "e" not in fdr and "E" not in fdr:
	fdr=str('%.2E' % Decimal(fdr))
    if "+" in fdr:
	print line,
    else:
    	order=int(fdr.split("-")[1])
        if order > threshold:
    	    print line,
