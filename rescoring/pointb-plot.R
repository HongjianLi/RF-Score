#!/usr/bin/env Rscript
d=read.csv('pointb.csv')
c="sdev"
xylim=c(min(d[,c]),max(d[,c]))
tiff("pointb.tiff", compression="lzw")
#pdf("pointb.pdf")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[d$model==2,c],d[d$model==3,c],xlim=xylim,ylim=xylim,xlab="MLR::Vina",ylab="RF::Vina",main="SD for both SFs on 50 test sets",pch=20)
abline(0, 1)
dev.off()
