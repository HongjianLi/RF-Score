#!/usr/bin/env Rscript
ms=c("mlr","rf","rf","rf")
xs=c(4,4,10,46)
ts=c("MLR::Cyscore","RF::Cyscore","RF::CyscoreVina","RF::CyscoreVinaElem")
nm=length(ms) # Number of models.
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
nc=length(statc) # Number of performance measures.
tsts=c(195,201,592)
ns=length(tsts) # Number of benchmarks.
pdf("stat.pdf",width=5*ns,height=5*nc)
layout(matrix(1:(nc*ns),nc,ns))
par(cex.lab=1.4,cex.axis=1.4)
for (tst in tsts)
{
	if (tst==195) {
		trns=c(247,1105)
	} else if (tst==201) {
		trns=c(247,2696)
	} else {
		trns=c(592,1184,1776,2367)
	}
	ntrn=length(trns) # Number of training sets.
	med=array(dim=c(nm,ntrn,nc))
	for (trni in 1:ntrn)
	{
		trn=trns[trni]
		for (mi in 1:nm)
		{
			stat=read.csv(sprintf("x%d/%s/trn-%d-tst-%d-stat.csv",xs[mi],ms[mi],trn,tst))
			for (ci in 1:nc)
			{
				med[mi,trni,ci]=stat[statc[ci]][,]
			}
		}
	}
	for (ci in 1:nc)
	{
		ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
		for (mi in 1:nm)
		{
			if (mi > 1) par(new=T)
			plot(trns,med[mi,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=mi,col=mi)
		}
		title(xlab=sprintf("Number of training complexes (N=%s)",paste(trns,collapse=",")),ylab=statx[ci])
		legend(ifelse(ci<=2,"bottomleft","topleft"),title="Models",legend=ts,fill=1:nm,cex=1.3)
		axis(1)
		axis(2)
	}
}
