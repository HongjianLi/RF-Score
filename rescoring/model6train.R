#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
w=as.numeric(args[2])
d=read.csv(sprintf("../pdbbind-%s-trn-yxi.csv",v)) # d[1] is pbindaff in pKd unit, d[2] to d[37] are Elem's 36 terms, d[38] to d[42] are Vina's 5 unweighted terms, d[43] and d[44] are N(ActTors) and N(InactTors).
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["z"]=d["pbindaff"]*d["t"] # Measured pKd times the flexibility penalty.
r=lm(z~X6.6+X7.6+X8.6+X16.6+X6.7+X7.7+X8.7+X16.7+X6.8+X7.8+X8.8+X16.8+X6.16+X7.16+X8.16+X16.16+X6.15+X7.15+X8.15+X16.15+X6.9+X7.9+X8.9+X16.9+X6.17+X7.17+X8.17+X16.17+X6.35+X7.35+X8.35+X16.35+X6.53+X7.53+X8.53+X16.53+gauss1+gauss2+repulsion+hydrophobic+hydrogenbonding,d) # Linear regression of Elem's 36 terms and Vina's 5 unweighted terms.
c=coefficients(r) # Trained weights.
write.csv(c,quote=F,file=sprintf("pdbbind-%s.csv",v))
