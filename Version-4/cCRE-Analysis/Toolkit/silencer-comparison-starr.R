
d=read.table("tmp.results")
aggregate(d$V2, list(d$V3), FUN=median)
pairwise.wilcox.test(d$V2,d$V3, p.adj="fdr")
table(d$V3)
