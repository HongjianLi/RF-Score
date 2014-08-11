#!/usr/bin/env Rscript
nm=4 # Number of models.
ns=2 # Number of datasets, e.g. 2.
nv=4 # Number of training sets per dataset, e.g. 4.
nc=5 # Number of performance measures.
setv=array(dim=c(ns,nv))
setv[1,]=c(2004,2007,2010,2013)
setv[2,]=c(2002,2007,2010,2012)
statc=c("rmse","sdev","pcor","scor","kcor")
statx=c("RMSE","SD","Rp","Rs","Rk")
for (trn in 1:6)
{
	cat(sprintf("trn%s\n",trn))
	if (trn >= 5) tsts = trn:trn else tsts = 1:2
	for (tst in tsts)
	{
		cat(sprintf("tst%s\n",tst))
		# Plot figures with y axis being the performance measure and x axis being the numbers of training complexes.
		cat(sprintf("model$m/set$s/trn-$trn-tst-$tst-$c-boxplot.tiff\n"))
		for (m in 2:nm)
		{
			cat(sprintf("model%d\n",m))
			for (s in 1:ns)
			{
				cat(sprintf("set%d\n",s))
				ntrn=array(dim=nv)
				box=array(list(),dim=c(nc,nv))
				med=array(dim=c(nc,nv))
				for (vi in 1:nv)
				{
					v=setv[s,vi]
					trn_stat=read.csv(sprintf("model%d/set%d/pdbbind-%s-trn-%s-trn-%s-stat.csv",m,s,v,trn,trn))
					tst_stat=read.csv(sprintf("model%d/set%d/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,v,trn,tst))
					ntrn[vi]=trn_stat["n"][1,]
					for (ci in 1:nc)
					{
						box[ci,vi]=tst_stat[statc[ci]]
						med[ci,vi]=median(tst_stat[statc[ci]][,])
					}
				}
				for (ci in 1:nc)
				{
					tiff(sprintf("model%d/set%d/trn-%s-tst-%s-%s-boxplot.tiff",m,s,trn,tst,statc[ci]),compression="lzw")
					par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
					boxplot(box[ci,],main=sprintf("Boxplot of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci],range=0,xaxt="n")
					axis(1,at=1:nv,labels=ntrn)
					dev.off()
					tiff(sprintf("model%d/set%d/trn-%s-tst-%s-%s-median.tiff",m,s,trn,tst,statc[ci]),compression="lzw")
					par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
					plot(ntrn,med[ci,],main=sprintf("Median of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci],pch=3)
					dev.off()
				}
			}
		}
		# Plot figures with y axis being the performance measure and x axis being the models trained on a specific training set.
		cat(sprintf("set$s/pdbbind-$v-trn-$trn-tst-$tst-$c-boxplot.tiff\n"))
		for (s in 1:ns)
		{
			cat(sprintf("set%d\n",s))
			for (vi in 1:nv)
			{
				v=setv[s,vi]
				cat(sprintf("v%d\n",v))
				box=array(list(),dim=c(nc,nm))
				med=array(dim=c(nc,nm))
				for (m in ifelse(trn>=5,2,1):nm)
				{
					tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,v),ifelse(m==1,1,trn),tst))
					for (ci in 1:nc)
					{
						box[ci,m]=tst_stat[statc[ci]]
						med[ci,m]=median(tst_stat[statc[ci]][,])
					}
				}
				for (ci in 1:nc)
				{
					tiff(sprintf("set%d/pdbbind-%s-trn-%s-tst-%s-%s-boxplot.tiff",s,v,trn,tst,statc[ci]),compression="lzw")
					par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
					boxplot(box[ci,ifelse(trn>=5,2,1):nm],main=sprintf("Boxplot of %s",statx[ci]),xlab="Model",ylab=statx[ci],range=0,names=ifelse(trn>=5,2,1):nm)
					dev.off()
					tiff(sprintf("set%d/pdbbind-%s-trn-%s-tst-%s-%s-median.tiff",s,v,trn,tst,statc[ci]),compression="lzw")
					par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
					plot(ifelse(trn>=5,2,1):nm,med[ci,ifelse(trn>=5,2,1):nm],main=sprintf("Median of %s",statx[ci]),xlab="Model",ylab=statx[ci],pch=3,xaxt="n")
					axis(1,ifelse(trn>=5,2,1):nm)
					dev.off()
				}
			}
		}
		# Plot figures with y axis being the performance measure, x axis being the numbers of training complexes, and legends being the models.
		cat(sprintf("set$s/trn-$trn-tst-$tst-$c-boxplot.tiff\n"))
		for (s in 1:ns)
		{
			cat(sprintf("set%d\n",s))
			ntrn=array(dim=nv)
			box=array(list(),dim=c(nm,nv,nc))
			med=array(dim=c(nm,nv,nc))
			for (vi in 1:nv)
			{
				v=setv[s,vi]
				trn_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-trn-%s-stat.csv",2,s,v,trn,trn))
				ntrn[vi]=trn_stat["n"][1,1]
				for (m in ifelse(trn>=5,2,1):nm)
				{
					tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,v),ifelse(m==1,1,trn),tst))
					for (ci in 1:nc)
					{
						box[m,vi,ci]=tst_stat[statc[ci]]
						med[m,vi,ci]=median(tst_stat[statc[ci]][,])
					}
				}
			}
			for (ci in 1:nc)
			{
				tiff(sprintf("set%d/trn-%s-tst-%s-%s-boxplot.tiff",s,trn,tst,statc[ci]),compression="lzw")
				par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
				ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
				for (m in ifelse(trn>=5,2,1):nm)
				{
					boxplot(box[m,,ci],ylim=ylim,xaxt="n",yaxt="n",xlab="",ylab="",range=0,border=m)
					par(new=T)
				}
				title(main=sprintf("Boxplot of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci])
				legend(ifelse(ci<=2,"topright","bottomright"),title="Models",legend=ifelse(trn>=5,2,1):nm,fill=ifelse(trn>=5,2,1):nm,cex=1.3)
				axis(1,at=1:nv,labels=ntrn)
				axis(2)
				dev.off()
				tiff(sprintf("set%d/trn-%s-tst-%s-%s-median.tiff",s,trn,tst,statc[ci]),compression="lzw")
				par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
				for (m in 2:nm)
				{
					plot(ntrn,med[m,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=m,col=m)
					par(new=T)
				}
				abline(h=med[1,,ci])
				title(main=sprintf("Median of %s",statx[ci]),xlab="Number of training complexes",ylab=statx[ci])
				legend(ifelse(ci<=2,"topright","bottomright"),title="Models",legend=ifelse(trn>=5,2,1):nm,fill=ifelse(trn>=5,2,1):nm,cex=1.3)
				axis(1)
				axis(2)
				dev.off()
			}
		}
	}
}
# Plot figures with y axis being the performance measure, x axis being the test schemes, and legends being the models.
ntst=2
ps=c(2007,2012)
for (trn in 1:4)
{
	cat(sprintf("set$s/pdbbind-%s-trn-$trn-$c-boxplot.tiff\n",ps[trn]))
	for (s in 1:ns)
	{
		cat(sprintf("set%d\n",s))
		box=array(list(),dim=c(nm,ntst,nc))
		med=array(dim=c(nm,ntst,nc))
		for (tst in 1:ntst)
		{
			for (m in 1:nm)
			{
				tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,ps[trn]),ifelse(m==1,1,trn),tst))
				for (ci in 1:nc)
				{
					box[m,tst,ci]=tst_stat[statc[ci]]
					med[m,tst,ci]=median(tst_stat[statc[ci]][,])
				}
			}
		}
		for (ci in 1:nc)
		{
			ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
			tiff(sprintf("set%d/pdbbind-%s-trn-%s-%s-boxplot.tiff",s,ps[trn],trn,statc[ci]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			for (m in 1:nm)
			{
				boxplot(box[m,,ci],ylim=ylim,xaxt="n",yaxt="n",xlab="",ylab="",range=0,border=m)
				par(new=T)
			}
			title(main=sprintf("Boxplot of %s",statx[ci]),xlab="Test pose",ylab=statx[ci])
			legend(ifelse(ci<=2,"topright","bottomright"),title="Models",legend=1:nm,fill=1:nm,cex=1.3)
			axis(1,at=1:ntst,labels=c("crystal","docked"))
			axis(2)
			dev.off()
			tiff(sprintf("set%d/pdbbind-%s-trn-%s-%s-median.tiff",s,ps[trn],trn,statc[ci]),compression="lzw")
			par(cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			for (m in 1:nm)
			{
				plot(1:ntst,med[m,,ci],ylim=ylim,type="b",xaxt="n",yaxt="n",xlab="",ylab="",pch=m,col=m)
				par(new=T)
			}
			title(main=sprintf("Median of %s",statx[ci]),xlab="Test pose",ylab=statx[ci])
			legend(ifelse(ci<=2,"topright","bottomright"),title="Models",legend=1:nm,fill=1:nm,cex=1.3)
			axis(1,at=1:ntst,labels=c("crystal","docked"))
			axis(2)
			dev.off()
		}
	}
}
