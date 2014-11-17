#!/usr/bin/env Rscript
nm=4 # Number of models.
nc=5 # Number of performance measures.
ns=2 # Number of datasets.
nva=c(4,5) # Number of training sets per dataset.
setv=array(dim=c(ns,max(nva)))
setv[1,]=c(2004,2007,2010,2013,0)
setv[2,]=c(2002,2007,2010,2012,2014)
statc=c("rmse","sdev","pcor","scor","kcor")
statx=c("RMSE","SD","Rp","Rs","Rk")
# Plot figures with y axis being the performance measure and x axis being the numbers of training complexes.
cat(sprintf("model$m/set$s/tst-$c-boxplot.tiff\n"))
for (m in 2:5)
{
	cat(sprintf("model%d\n",m))
	for (s in 1:ns)
	{
		cat(sprintf("set%d\n",s))
		nv=nva[s]
		ntrn=array(dim=nv)
		box=array(list(),dim=c(nc,nv))
		med=array(dim=c(nc,nv))
		for (vi in 1:nv)
		{
			v=setv[s,vi]
			trn_stat=read.csv(sprintf("model%d/set%d/pdbbind-%s-trn-stat.csv",m,s,v))
			tst_stat=read.csv(sprintf("model%d/set%d/pdbbind-%s-tst-stat.csv",m,s,v))
			ntrn[vi]=trn_stat["n"][1,]
			for (ci in 1:nc)
			{
				box[ci,vi]=tst_stat[statc[ci]]
				med[ci,vi]=median(tst_stat[statc[ci]][,])
			}
		}
		for (ci in 1:nc)
		{
			tiff(sprintf("model%d/set%d/tst-%s-boxplot.tiff",m,s,statc[ci]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			boxplot(box[ci,],main=sprintf("Boxplot of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci],range=0,xaxt="n")
			axis(1,at=1:nv,labels=ntrn)
			dev.off()
			tiff(sprintf("model%d/set%d/tst-%s-median.tiff",m,s,statc[ci]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			plot(ntrn,med[ci,],main=sprintf("Median of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci],pch=3)
			dev.off()
		}
	}
}
# Plot figures with y axis being the performance measure and x axis being the models trained on a specific training set.
cat(sprintf("set$s/pdbbind-$v-tst-$c-boxplot.tiff\n"))
for (s in 1:ns)
{
	cat(sprintf("set%d\n",s))
	nv=nva[s]
	for (vi in 1:nv)
	{
		v=setv[s,vi]
		cat(sprintf("v%d\n",v))
		box=array(list(),dim=c(nc,nm))
		med=array(dim=c(nc,nm))
		for (m in 1:nm)
		{
			tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-tst-stat.csv",m,s,ifelse(m==1,2007,v)))
			for (ci in 1:nc)
			{
				box[ci,m]=tst_stat[statc[ci]]
				med[ci,m]=median(tst_stat[statc[ci]][,])
			}
		}
		for (ci in 1:nc)
		{
			tiff(sprintf("set%d/pdbbind-%s-tst-%s-boxplot.tiff",s,v,statc[ci]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			boxplot(box[ci,],main=sprintf("Boxplot of %s",statx[ci]),xlab="Model",ylab=statx[ci],range=0)
			dev.off()
			tiff(sprintf("set%d/pdbbind-%s-tst-%s-median.tiff",s,v,statc[ci]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			plot(1:nm,med[ci,],main=sprintf("Median of %s",statx[ci]),xlab="Model",ylab=statx[ci],pch=3,xaxt="n")
			axis(1,1:nm)
			dev.off()
		}
	}
}
# Plot figures with y axis being the performance measure, x axis being the numbers of training complexes, and legends being the models.
cat(sprintf("set$s/tst-$c-boxplot.tiff\n"))
for (s in 1:ns)
{
	cat(sprintf("set%d\n",s))
	nv=nva[s]
	ntrn=array(dim=nv)
	box=array(list(),dim=c(nm,nv,nc))
	med=array(dim=c(nm,nv,nc))
	for (vi in 1:nv)
	{
		v=setv[s,vi]
		trn_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-stat.csv",2,s,v))
		ntrn[vi]=trn_stat["n"][1,1]
		for (m in 1:nm)
		{
			tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-tst-stat.csv",m,s,ifelse(m==1,2007,v)))
			for (ci in 1:nc)
			{
				box[m,vi,ci]=tst_stat[statc[ci]]
				med[m,vi,ci]=median(tst_stat[statc[ci]][,])
			}
		}
	}
	for (ci in 1:nc)
	{
		legend.x = ifelse(ci<=2,"bottomleft","topleft")
		tiff(sprintf("set%d/tst-%s-boxplot.tiff",s,statc[ci]),compression="lzw")
		par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
		ylim=c(min(med[,,ci]),max(med[,,ci]))
		for (m in 1:nm)
		{
			boxplot(box[m,,ci],ylim=ylim,xaxt="n",yaxt="n",xlab="",ylab="",range=0,border=m)
			par(new=T)
		}
		title(main=sprintf("Boxplot of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci])
		legend(legend.x,title="Models",legend=1:nm,fill=1:nm,cex=1.3)
		axis(1,at=1:nv,labels=ntrn)
		axis(2)
		dev.off()
		tiff(sprintf("set%d/tst-%s-median.tiff",s,statc[ci]),compression="lzw")
		par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
		for (m in 2:nm)
		{
			plot(ntrn,med[m,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=m,col=m)
			par(new=T)
		}
		abline(h=med[1,,ci])
		title(main=sprintf("Median of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci])
		legend(legend.x,title="Models",legend=1:nm,fill=1:nm,cex=1.3)
		axis(1)
		axis(2)
		dev.off()
	}
}
