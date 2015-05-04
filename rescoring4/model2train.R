#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
w=as.numeric(args[3])
d=read.csv(sprintf("../pdbbind-%s-trn-%s-yxi.csv",v,trn)) # d[1] is pbindaff in pKd unit, d[2] to d[6] are Vina's 5 unweighted terms, d[7] and d[8] are N(ActTors) and N(InactTors).
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["z"]=d["pbindaff"]*d["t"] # Measured pKd times the flexibility penalty.
r=lm(z~gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding,d) # Linear regression of Vina's 5 unweighted terms.
c=coefficients(r) # Trained weights.
write.csv(c,quote=F,file=sprintf("pdbbind-%s-trn-%s.csv",v,trn))
