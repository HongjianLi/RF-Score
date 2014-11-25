#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
t=args[3]
d=read.csv(sprintf("pdbbind-%s-trn-%s-%s-iyp.csv",v,trn,t))
n=nrow(d)
rmse=sqrt(sum((d["predicted"]-d["pbindaff"])^2)/n)
sdev=summary(lm(pbindaff~predicted,d))$sigma
pcor=cor(d["predicted"], d["pbindaff"], method="pearson")
scor=cor(d["predicted"], d["pbindaff"], method="spearman")
kcor=cor(d["predicted"], d["pbindaff"], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.2f,%.2f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("pdbbind-%s-trn-%s-%s-stat.csv",v,trn,t))
