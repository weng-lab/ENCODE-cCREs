import sys
a=int(sys.argv[2])-1
b=int(sys.argv[3])-1
c=int(sys.argv[4])-1

predDict={}

for line in open(sys.argv[1]):
    line=line.rstrip().split("\t")
    if line[a] not in predDict:
	try:
        	predDict[line[a]]={line[b]:int(line[c])}
	except:
		print line
    else:
	if line[b] in predDict[line[a]]:
		predDict[line[a]][line[b]] += int(line[c])
	else:
		predDict[line[a]][line[b]] = int(line[c])
for entry in predDict:
    m=0
    s=""
    for sub in predDict[entry]:
	if predDict[entry][sub] > m:
		s=sub
		m=predDict[entry][sub]
    print entry, "\t", s, "\t", m

