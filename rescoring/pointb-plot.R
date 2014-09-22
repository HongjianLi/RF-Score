#!/usr/bin/env Rscript
d=as.matrix(read.csv('pointb.csv'))
c="sdev"
xylim=c(min(d[,c]),max(d[,c]))
#tiff("pointb.tiff", compression="lzw")
pdf("pointb.pdf")
par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
plot(d[2:51,c],d[53:102,c],xlim=xylim,ylim=xylim,xlab="MLR::Vina",ylab="RF::VinaElem",main="Scatter plot of SD of models 2 and 4 on 50 test sets")
abline(0, 1)
dev.off()
