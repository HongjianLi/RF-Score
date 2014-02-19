#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
iyp=read.csv(sprintf("pdbbind-%s-trn-%s-tst-%s-iyp.csv",v,trn,tst),check.names=F)
n=nrow(iyp)
se=sum((iyp[3] - iyp[2])^2)
rmse=sqrt(se/n)
sdev=sqrt(se/(n-1))
pcor=cor(iyp[3], iyp[2], method="pearson")
scor=cor(iyp[3], iyp[2], method="spearman")
kcor=cor(iyp[3], iyp[2], method="kendall")
xylim=c(2,14) # Set1's range.
if (n == 382) xylim=c(1,12) # Set2's range.
tiff(sprintf("pdbbind-%s-trn-%s-tst-%s-iyp.tiff",v,trn,tst),compress="lzw")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(iyp[,2], iyp[,3], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
abline(lm(iyp[,3] ~ iyp[,2]))
grid()