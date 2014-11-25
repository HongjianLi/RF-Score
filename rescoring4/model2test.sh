#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
w=as.numeric(args[3])
t=args[4]
c=read.csv(sprintf("pdbbind-%s-trn-%s.csv",v,trn))[,2]
d=read.csv(ifelse(substr(t,1,3)=="tst",sprintf("../%s-yxi.csv",t),sprintf("../pdbbind-%s-trn-%s-yxi.csv",v,trn))) # d[1] is pbindaff in pKd unit, d[2] to d[6] are Vina's 5 unweighted terms, d[7] and d[8] are N(ActTors) and N(InactTors).
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["predicted"]=(c[1]+d[2]*c[2]+d[3]*c[3]+d[4]*c[4]+d[5]*c[5]+d[6]*c[6])/d["t"] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
write.csv(c(d["PDB"],round(d["pbindaff"],2),round(d["predicted"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-trn-%s-%s-iyp.csv",v,trn,t)) # Write the measured binding affinities and the predicted ones in CSV format.
