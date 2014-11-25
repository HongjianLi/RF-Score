#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
w=as.numeric(args[3])
d=read.csv(sprintf("../pdbbind-%s-trn-%s-yxi.csv",v,trn)) # d[1] is pbindaff in pKd unit, d[2] to d[11] are Vina's 10 unweighted terms, d[12] and d[13] are N(ActTors) and N(InactTors).
nc=ncol(d) # Number of columns, to distinguish between schemes 1,2,3,4 and scheme 5.
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["z"]=d["pbindaff"]*d["t"] # Measured pKd times the flexibility penalty.
if (nc == 14) {
	r=lm(z~gauss1_inter+gauss2_inter+repulsion_inter+hydrophobic_inter+hydrogenbonding_inter+gauss1_intra+gauss2_intra+repulsion_intra+hydrophobic_intra+hydrogenbonding_intra,d) # Linear regression of Vina's 10 unweighted terms.
} else if (nc == 24) {
	r=lm(z~gauss1_inter_1+gauss2_inter_1+repulsion_inter_1+hydrophobic_inter_1+hydrogenbonding_inter_1+gauss1_intra_1+gauss2_intra_1+repulsion_intra_1+hydrophobic_intra_1+hydrogenbonding_intra_1+gauss1_inter_2+gauss2_inter_2+repulsion_inter_2+hydrophobic_inter_2+hydrogenbonding_inter_2+gauss1_intra_2+gauss2_intra_2+repulsion_intra_2+hydrophobic_intra_2+hydrogenbonding_intra_2,d) # Linear regression of Vina's 10 unweighted terms over 2 poses.
} else if (nc == 94) {
	r=lm(z~gauss1_inter_1+gauss2_inter_1+repulsion_inter_1+hydrophobic_inter_1+hydrogenbonding_inter_1+gauss1_intra_1+gauss2_intra_1+repulsion_intra_1+hydrophobic_intra_1+hydrogenbonding_intra_1+gauss1_inter_2+gauss2_inter_2+repulsion_inter_2+hydrophobic_inter_2+hydrogenbonding_inter_2+gauss1_intra_2+gauss2_intra_2+repulsion_intra_2+hydrophobic_intra_2+hydrogenbonding_intra_2+gauss1_inter_3+gauss2_inter_3+repulsion_inter_3+hydrophobic_inter_3+hydrogenbonding_inter_3+gauss1_intra_3+gauss2_intra_3+repulsion_intra_3+hydrophobic_intra_3+hydrogenbonding_intra_3+gauss1_inter_4+gauss2_inter_4+repulsion_inter_4+hydrophobic_inter_4+hydrogenbonding_inter_4+gauss1_intra_4+gauss2_intra_4+repulsion_intra_4+hydrophobic_intra_4+hydrogenbonding_intra_4+gauss1_inter_5+gauss2_inter_5+repulsion_inter_5+hydrophobic_inter_5+hydrogenbonding_inter_5+gauss1_intra_5+gauss2_intra_5+repulsion_intra_5+hydrophobic_intra_5+hydrogenbonding_intra_5+gauss1_inter_6+gauss2_inter_6+repulsion_inter_6+hydrophobic_inter_6+hydrogenbonding_inter_6+gauss1_intra_6+gauss2_intra_6+repulsion_intra_6+hydrophobic_intra_6+hydrogenbonding_intra_6+gauss1_inter_7+gauss2_inter_7+repulsion_inter_7+hydrophobic_inter_7+hydrogenbonding_inter_7+gauss1_intra_7+gauss2_intra_7+repulsion_intra_7+hydrophobic_intra_7+hydrogenbonding_intra_7+gauss1_inter_8+gauss2_inter_8+repulsion_inter_8+hydrophobic_inter_8+hydrogenbonding_inter_8+gauss1_intra_8+gauss2_intra_8+repulsion_intra_8+hydrophobic_intra_8+hydrogenbonding_intra_8+gauss1_inter_9+gauss2_inter_9+repulsion_inter_9+hydrophobic_inter_9+hydrogenbonding_inter_9+gauss1_intra_9+gauss2_intra_9+repulsion_intra_9+hydrophobic_intra_9+hydrogenbonding_intra_9,d) # Linear regression of Vina's 10 unweighted terms over 9 poses.
} else {
	write(sprintf("nc=%d is unsupported",nc), stderr())
	quit()
}
c=coefficients(r) # Trained weights.
write.csv(round(c,6),quote=F,file=sprintf("pdbbind-%s-trn-%s-coef.csv",v,trn))
