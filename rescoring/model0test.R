#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
w=as.numeric(args[2])
t=args[3]
c=read.csv(sprintf("pdbbind-%s.csv",v))[,2]
d=read.csv(ifelse(t=="tst","../tst-yxi.csv",sprintf("../pdbbind-%s-trn-yxi.csv",v))) # d[1] is pbindaff in pKd unit, d[1] is nha, d[2] is mwt, d[3] is PDB.
d["predicted"]=c[1]+d[w]*c[2]
write.csv(c(d["PDB"],round(d["pbindaff"],2),round(d["predicted"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-%s-iyp.csv",v,t)) # Write the measured binding affinities and the predicted ones in CSV format.
