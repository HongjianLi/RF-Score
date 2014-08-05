#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
w=as.numeric(args[2])
d=read.csv(sprintf("../pdbbind-%s-trn-yxi.csv",v)) # d[1] is pbindaff in pKd unit, d[2] is nha, d[3] is mwt, d[4] is PDB.
h=colnames(d)
h[w]="var"
colnames(d)=h
r=lm(pbindaff~var, d) # Linear regression.
c=coefficients(r) # Trained weights.
write.csv(c,quote=F,file=sprintf("pdbbind-%s.csv",v))
