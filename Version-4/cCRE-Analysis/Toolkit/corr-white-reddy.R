
args <- commandArgs(trailingOnly = TRUE)
d=read.table(args[1])

R=cor.test(d$V2,d$V3)$estimate
p=cor.test(d$V2,d$V3)$p.value

cat(paste(R,p,"\n"))
