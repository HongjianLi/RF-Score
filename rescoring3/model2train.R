#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
w=as.numeric(args[3])
d=read.csv(sprintf("../pdbbind-%s-trn-%s-yxi.csv",v,trn))
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"])
d["z"]=d["pbindaff"]*d["t"]
r=lm(z~gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding,d)
c=coefficients(r)
write.csv(round(c,6),quote=F,file=sprintf("pdbbind-%s-trn-%s-coef.csv",v,trn))
