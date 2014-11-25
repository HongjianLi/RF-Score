#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
d=read.csv(sprintf("pdbbind-%s-trn-%s-tst-%s-iyp.csv",v,trn,tst))
n=nrow(d) # Number of samples.
xylim=c(0,ifelse(sort(d$pbindaff,decreasing=T)[1]<12,12,14))
rmse=sqrt(sum((d["predicted"]-d["pbindaff"])^2)/n)
sdev=summary(lm(pbindaff~predicted,d))$sigma
pcor=cor(d["predicted"], d["pbindaff"], method="pearson")
scor=cor(d["predicted"], d["pbindaff"], method="spearman")
kcor=cor(d["predicted"], d["pbindaff"], method="kendall")
cat(sprintf("n,rmse,sdev,pcor,scor,kcor\n%d,%.2f,%.2f,%.3f,%.3f,%.3f\n", n, rmse, sdev, pcor, scor, kcor), file=sprintf("pdbbind-%s-trn-%s-tst-%s-stat.csv",v,trn,tst))
tiff(sprintf("pdbbind-%s-trn-%s-tst-%s-yp.tiff",v,trn,tst),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[,"pbindaff"], d[,"predicted"], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
abline(lm(d[,"predicted"] ~ d[,"pbindaff"]))
grid()
