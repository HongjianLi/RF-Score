#!/usr/bin/env Rscript
nm=4 # Number of models.
ns=2 # Number of datasets.
nv=4 # Number of training sets per dataset.
nc=4 # Number of performance measures.
ntrn=2 # Number of training schemes.
ntst=2 # Number of test schemes.
ntrntst=ntrn*ntst
setv=array(dim=c(ns,nv))
setv[1,]=c(2004,2007,2010,2013)
setv[2,]=c(2002,2007,2010,2012)
ps=c(2007,2012)
statc=c("rmse","sdev","pcor","scor")
statx=c("RMSE","SD","Rp","Rs")
for (s in 1:ns) {
	v=ps[s]
	for (trn in 1:ntrn) {
		for (tst in 1:ntst) {
			ws=c("",NULL,NULL,NULL)
			for (m in 2:nm) {
				stat=read.csv(sprintf("model%s/set%s/tst-stat.csv",m,s,v,trn,tst))
				stat=stat[stat["v"]==v,]
				stat=stat[stat["trn"]==trn,]
				stat=stat[stat["tst"]==tst,]
				w=stat[,"w"]
				if (m==2) w=sprintf("%.3f",w)
				ws[m]=w
			}
			# set%s/pdbbind-%s-trn-%s-tst-%s-yp plots, aggregating over models.
			out=sprintf("set%s/pdbbind-%s-trn-%s-tst-%s-yp.pdf",s,v,trn,tst)
			print(out)
			pdf(out,width=5*nm/2,height=5*nm/2)
			par(mfrow=c(2,2),cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			for (m in 1:nm) {
				w=ws[m]
				iyp=read.csv(sprintf("model%s/set%s/%s/pdbbind-%s-trn-%s-tst-%s-iyp.csv",m,s,w,ifelse(m==1,2007,v),ifelse(m==1,1,trn),tst))
				n=nrow(iyp)
				xylim=c(0,ifelse(sort(iyp$pbindaff,decreasing=T)[1]<12,12,14))
				rmse=sqrt(sum((iyp["predicted"]-iyp["pbindaff"])^2)/n)
				sdev=summary(lm(pbindaff~predicted,iyp))$sigma
				pcor=cor(iyp["predicted"], iyp["pbindaff"], method="pearson")
				scor=cor(iyp["predicted"], iyp["pbindaff"], method="spearman")
				kcor=cor(iyp["predicted"], iyp["pbindaff"], method="kendall")
				plot(iyp[,"pbindaff"], iyp[,"predicted"], xlim=xylim, ylim=xylim, xlab="Measured binding affinity (pKd)", ylab=sprintf("Predicted binding affinity (pKd) by model %s",m), main=sprintf("N=%d, RMSE=%.2f, SD=%.2f, Rp=%.3f, Rs=%.3f", n, rmse, sdev, pcor, scor))
				abline(lm(iyp[,"predicted"] ~ iyp[,"pbindaff"]))
				grid()
			}
			dev.off()
			# set%s/pdbbind-%s-trn-%s-tst-%s-de plots, aggregating over models.
			out=sprintf("set%s/pdbbind-%s-trn-%s-tst-%s-de.pdf",s,v,trn,tst)
			print(out)
			pdf(out,width=5*nm/2,height=5*nm/2)
			par(mfrow=c(2,2),cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			for (m in 1:nm) {
				w=ws[m]
				iyp=read.csv(sprintf("model%s/set%s/%s/pdbbind-%s-trn-%s-tst-%s-iyp.csv",m,s,w,ifelse(m==1,2007,v),ifelse(m==1,1,trn),tst))
				id=read.csv(sprintf("set%s/tst-2-id.csv",s))
				u=15
				r=id["RMSD1"]<u
				n=nrow(id[r,])
				iyp[r,"error"]=abs(iyp[r,"predicted"]-iyp[r,"pbindaff"])
#				print(max(iyp[r,"error"]))
				pcor=cor(iyp[r,"error"], id[r,"RMSD1"], method="pearson")
				scor=cor(iyp[r,"error"], id[r,"RMSD1"], method="spearman")
				plot(id[r,"RMSD1"], iyp[r,"error"], xlim=c(0,u), ylim=c(0,8), xlab="RMSD (Å)", ylab=sprintf("Predicted binding affinity absolute error (pKd) by model %s",m), main=sprintf("N=%d, Rp=%.3f, Rs=%.3f", n, pcor, scor))
				abline(lm(iyp[r,"error"] ~ id[r,"RMSD1"]))
				axis(1,at=2)
				grid()
			}
			dev.off()
			# set%s/trn-%s-tst-%s-boxplot plots, aggregating over metrics.
			out=sprintf("set%s/trn-%s-tst-%s-boxplot.pdf",s,trn,tst)
			print(out)
			pdf(out,width=5*nc/2,height=5*nc/2)
			par(mfrow=c(2,2),cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
			trns=array(dim=nv)
			box=array(list(),dim=c(nm,nv,nc))
			med=array(dim=c(nm,nv,nc))
			for (vi in 1:nv) {
				vv=setv[s,vi]
				trn_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-trn-%s-stat.csv",2,s,vv,trn,trn))
				trns[vi]=trn_stat["n"][1,1]
				for (m in ifelse(trn>=5,2,1):nm) {
					tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,vv),ifelse(m==1,1,trn),tst))
					for (ci in 1:nc) {
						box[m,vi,ci]=tst_stat[statc[ci]]
						med[m,vi,ci]=median(tst_stat[statc[ci]][,])
					}
				}
			}
			for (ci in 1:nc) {
				legend.x = ifelse(ci<=2,"bottomleft","topleft")
				ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
				for (m in ifelse(trn>=5,2,1):nm) {
					boxplot(box[m,,ci],ylim=ylim,xaxt="n",yaxt="n",xlab="",ylab="",range=0,border=m)
					par(new=T)
				}
				title(xlab="Number of training complexes",ylab=statx[ci])
				legend(legend.x,title="Models",legend=ifelse(trn>=5,2,1):nm,fill=ifelse(trn>=5,2,1):nm,cex=1.3)
				axis(1,at=1:nv,labels=trns)
				axis(2)
			}
			dev.off()
		}
	}
	# set%s/pdbbind-%s-boxplot plots, aggregating over metrics
	out=sprintf("set%s/pdbbind-%s-boxplot.pdf",s,v)
	print(out)
	pdf(out,width=5*nc/2,height=5*nc/2)
	par(mfrow=c(2,2),cex.lab=1.3,cex.axis=1.3,cex.main=1.3)
	box=array(list(),dim=c(nm,ntrntst,nc))
	med=array(dim=c(nm,ntrntst,nc))
	labels=c()
	for (trn in 1:ntrn) {
		for (tst in 1:ntst) {
			for (m in 1:nm) {
				tst_stat=read.csv(sprintf("model%d/set%s/pdbbind-%s-trn-%s-tst-%s-stat.csv",m,s,ifelse(m==1,2007,v),ifelse(m==1,1,trn),tst))
				for (ci in 1:nc) {
					box[m,(trn-1)*2+tst,ci]=tst_stat[statc[ci]]
					med[m,(trn-1)*2+tst,ci]=median(tst_stat[statc[ci]][,])
				}
			}
			labels=c(labels,sprintf("trn:%s,tst:%s",trn,tst))
		}
	}
	for (ci in 1:nc) {
		ylim=c(min(med[,,ci],na.rm=T),max(med[,,ci],na.rm=T))
		for (m in 1:nm) {
			boxplot(box[m,,ci],ylim=ylim,xaxt="n",yaxt="n",xlab="",ylab="",range=0,border=m)
			par(new=T)
		}
		title(ylab=statx[ci])
		legend(ifelse(ci<=2,"topright","bottomright"),title="Models",legend=1:nm,fill=1:nm,cex=1.3)
		axis(1,at=1:ntrntst,labels=labels)
		axis(2)
	}
	dev.off()
}
