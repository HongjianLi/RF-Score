#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
trn=args[2]
tst=args[3]
w=as.numeric(args[4])
t=args[5]
c=read.csv(sprintf("pdbbind-%s-trn-%s-coef.csv",v,trn))[,2]
d=read.csv(ifelse(t=="tst",sprintf("../tst-%s-yxi.csv",tst),sprintf("../pdbbind-%s-trn-%s-yxi.csv",v,trn))) # d[1] is pbindaff in pKd unit, d[2] to d[11] are Vina's 10 unweighted terms.
nc=ncol(d) # Number of columns, to distinguish between schemes 1,2,3,4 and scheme 5.
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
if (nc == 14) {
	d["predicted"]=(c[1]+c[2]*d[2]+c[3]*d[3]+c[4]*d[4]+c[5]*d[5]+c[6]*d[6]+c[7]*d[7]+c[8]*d[8]+c[9]*d[9]+c[10]*d[10]+c[11]*d[11])/d["t"] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
} else if (nc == 24) {
	d["predicted"]=(c[1]+c[2]*d[2]+c[3]*d[3]+c[4]*d[4]+c[5]*d[5]+c[6]*d[6]+c[7]*d[7]+c[8]*d[8]+c[9]*d[9]+c[10]*d[10]+c[11]*d[11]+c[12]*d[12]+c[13]*d[13]+c[14]*d[14]+c[15]*d[15]+c[16]*d[16]+c[17]*d[17]+c[18]*d[18]+c[19]*d[19]+c[20]*d[20]+c[21]*d[21])/d["t"] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
} else if (nc == 94) {
	d["predicted"]=(c[1]+c[2]*d[2]+c[3]*d[3]+c[4]*d[4]+c[5]*d[5]+c[6]*d[6]+c[7]*d[7]+c[8]*d[8]+c[9]*d[9]+c[10]*d[10]+c[11]*d[11]+c[12]*d[12]+c[13]*d[13]+c[14]*d[14]+c[15]*d[15]+c[16]*d[16]+c[17]*d[17]+c[18]*d[18]+c[19]*d[19]+c[20]*d[20]+c[21]*d[21]+c[22]*d[22]+c[23]*d[23]+c[24]*d[24]+c[25]*d[25]+c[26]*d[26]+c[27]*d[27]+c[28]*d[28]+c[29]*d[29]+c[30]*d[30]+c[31]*d[31]+c[32]*d[32]+c[33]*d[33]+c[34]*d[34]+c[35]*d[35]+c[36]*d[36]+c[37]*d[37]+c[38]*d[38]+c[39]*d[39]+c[40]*d[40]+c[41]*d[41]+c[42]*d[42]+c[43]*d[43]+c[44]*d[44]+c[45]*d[45]+c[46]*d[46]+c[47]*d[47]+c[48]*d[48]+c[49]*d[49]+c[50]*d[50]+c[51]*d[51]+c[52]*d[52]+c[53]*d[53]+c[54]*d[54]+c[55]*d[55]+c[56]*d[56]+c[57]*d[57]+c[58]*d[58]+c[59]*d[59]+c[60]*d[60]+c[61]*d[61]+c[62]*d[62]+c[63]*d[63]+c[64]*d[64]+c[65]*d[65]+c[66]*d[66]+c[67]*d[67]+c[68]*d[68]+c[69]*d[69]+c[70]*d[70]+c[71]*d[71]+c[72]*d[72]+c[73]*d[73]+c[74]*d[74]+c[75]*d[75]+c[76]*d[76]+c[77]*d[77]+c[78]*d[78]+c[79]*d[79]+c[80]*d[80]+c[81]*d[81]+c[82]*d[82]+c[83]*d[83]+c[84]*d[84]+c[85]*d[85]+c[86]*d[86]+c[87]*d[87]+c[88]*d[88]+c[89]*d[89]+c[90]*d[90]+c[91]*d[91])/d["t"] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
} else {
	write(sprintf("nc=%d is unsupported",nc), stderr())
	quit()
}
write.csv(c(d["PDB"],round(d["pbindaff"],2),round(d["predicted"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-trn-%s-%s-%s-iyp.csv",v,trn,t,ifelse(t=="tst",tst,trn))) # Write the measured binding affinities and the predicted ones in CSV format.
