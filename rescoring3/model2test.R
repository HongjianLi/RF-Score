#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
w=as.numeric(args[4])
c=read.csv(sprintf("pdbbind-%s-trn-%s-coef.csv",v,trn))[,2]
d=read.csv(sprintf("../tst-%s-yxi.csv",tst))
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"])
d["predicted"]=(c[1]+c[2]*d[2]+c[3]*d[3]+c[4]*d[4]+c[5]*d[5]+c[6]*d[6])/d["t"]
write.table(round(d["predicted"],2),col.names=F,row.names=F,quote=F,file=sprintf("pdbbind-%s-trn-%s-tst-%s-p.csv",v,trn,tst))
