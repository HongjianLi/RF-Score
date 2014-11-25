#!/usr/bin/env Rscript
nm=4 # Number of models.
ns=2 # Number of datasets.
nv=7 # Number of training sets per dataset.
nc=5 # Number of performance measures.
ntrn=c(2897,3809,4356,4449,5752,6719,6881) # 6973
statc=c("rmse","sdev","pcor","scor","kcor")
statx=c("RMSE","SD","Rp","Rs","Rk")
# Plot figures with y axis being the performance measure, x axis being the numbers of training complexes, and legends being the models.
cat(sprintf("set$s/tst-$c-boxplot.tiff\n"))
for (s in 2:ns)
{
	cat(sprintf("set%d\n",s))
	v=2012
#	ntrn=array(dim=nv)
	box=array(list(),dim=c(nm,nv,nc))
	med=array(dim=c(nm,nv,nc))
	for (vi in 1:nv)
	{
#		trn_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-stat.csv",2,s,v,vi-1))
#		ntrn[vi]=trn_stat["n"][1,1]
		for (m in 1:nm)
		{
			tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-stat.csv",m,s,ifelse(m==1,2007,v),ifelse(m==1,0,vi-1)))
			for (ci in 1:nc)
			{
				box[m,vi,ci]=tst_stat[statc[ci]]
				med[m,vi,ci]=median(tst_stat[statc[ci]][,])
			}
		}
	}
	for (ci in 1:nc)
	{
		legend.x = ifelse(ci<=2,"topright","bottomright")
		tiff(sprintf("set%d/tst-%s-boxplot.tiff",s,statc[ci]),compression="lzw")
		par(cex.lab=1.3,cex.axis=1.29,cex.main=1.3)
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
	}
}
