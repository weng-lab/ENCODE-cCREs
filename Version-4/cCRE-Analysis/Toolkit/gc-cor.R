args <- commandArgs(trailingOnly = TRUE)
d=read.table(args[1])


gc=round(cor.test(d$V3,d$V5)$estimate,2)
cpg=round(cor.test(d$V3,d$V6)$estimate,2)
cg_norm=round(cor.test(d$V3,d$V7)$estimate,2)

cat(paste(gc, cpg, cg_norm, "\n", sep="\t"))
