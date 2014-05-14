#!/usr/bin/env Rscript
xylim=c(0,14)
xs=c(4,46)
ms=c("mlr","rf")
nm=length(ms) # Number of models.
tsts=c(195,201,592)
ns=length(tsts) # Number of benchmarks.
#pdf("cor.pdf",width=5*ns,height=5*nm)
setEPS()
postscript("cor.eps",width=5*ns,height=5*nm)
layout(matrix(1:(nm*ns),2,ns,byrow=T))
par(cex.lab=1.4,cex.axis=1.4,cex.main=1.4)
for (mi in 1:2)
{
	x=xs[mi]
	m=ms[mi]
	for (tst in tsts)
	{
		if (mi==1) {
			trn=247
		} else if (tst==195) {
			trn=1105
		} else if (tst==201) {
			trn=2696
		} else {
			trn=2367
		}
		d=read.csv(sprintf("x%d/%s/trn-%s-tst-%s-iyp.csv",x,m,trn,tst))
		n=nrow(d) # Number of samples.
		rmse=sqrt(sum((d["predicted"] - d["pbindaff"])^2)/n)
		sdev=summary(lm(pbindaff~predicted,d))$sigma
		pcor=cor(d["predicted"], d["pbindaff"], method="pearson")
		scor=cor(d["predicted"], d["pbindaff"], method="spearman")
		kcor=cor(d["predicted"], d["pbindaff"], method="kendall")
		plot(d[,"pbindaff"], d[,"predicted"], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab="Predicted binding affinity (pKd)", main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
		abline(lm(d[,"predicted"]~d[,"pbindaff"]))
		grid()
	}
}
