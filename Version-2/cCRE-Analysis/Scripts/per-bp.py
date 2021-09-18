import sys

chrom=sys.argv[1]
start=int(sys.argv[2])
stop=int(sys.argv[3])

mid=(start+stop)/2

x=-250
for i in range(mid-250, mid+251):
    print chrom+"\t"+str(i)+"\t"+str(i+1)+"\t"+str(x)
    x+=1




