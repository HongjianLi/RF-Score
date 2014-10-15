#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
t=args[2]
d=read.csv(sprintf("pdbbind-%s-%s-iyp.csv",v,t))
n=nrow(d)
rmse=sqrt(sum((d["predicted"]-d["pbindaff"])^2)/n)
sdev=summary(lm(pbindaff~predicted,d))$sigma
pcor=cor(d["predicted"], d["pbindaff"], method="pearson")
scor=cor(d["predicted"], d["pbindaff"], method="spearman")
kcor=cor(d["predicted"], d["pbindaff"], method="kendall")
xylim=c(0,14)
if (n == 382) xylim=c(0,12)
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.2f,%.2f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("pdbbind-%s-%s-stat.csv",v,t))
tiff(sprintf("pdbbind-%s-%s-yp.tiff",v,t),compression="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,"pbindaff"], d[,"predicted"], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
abline(lm(d[,"predicted"]~d[,"pbindaff"]))
grid()
