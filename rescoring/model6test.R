#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
v=args[1]
w=as.numeric(args[2])
t=args[3]
c=read.csv(sprintf("pdbbind-%s.csv",v))[,2]
d=read.csv(ifelse(substr(t,1,3)=="tst",sprintf("../%s-yxi.csv",t),sprintf("../pdbbind-%s-trn-yxi.csv",v))) # d[1] is pbindaff in pKd unit, d[2] to d[37] are Elem's 36 terms, d[38] to d[42] are Vina's 5 unweighted terms, d[43] and d[44] are N(ActTors) and N(InactTors).
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["predicted"]=(c[1]+d[2]*c[2]+d[3]*c[3]+d[4]*c[4]+d[5]*c[5]+d[6]*c[6]+d[7]*c[7]+d[8]*c[8]+d[9]*c[9]+d[10]*c[10]+d[11]*c[11]+d[12]*c[12]+d[13]*c[13]+d[14]*c[14]+d[15]*c[15]+d[16]*c[16]+d[17]*c[17]+d[18]*c[18]+d[19]*c[19]+d[20]*c[20]+d[21]*c[21]+d[22]*c[22]+d[23]*c[23]+d[24]*c[24]+d[25]*c[25]+d[26]*c[26]+d[27]*c[27]+d[28]*c[28]+d[29]*c[29]+d[30]*c[30]+d[31]*c[31]+d[32]*c[32]+d[33]*c[33]+d[34]*c[34]+d[35]*c[35]+d[36]*c[36]+d[37]*c[37]+d[38]*c[38]+d[39]*c[39]+d[40]*c[40]+d[41]*c[41]+d[42]*c[42])/d["t"] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
write.csv(c(d["PDB"],round(d["pbindaff"],2),round(d["predicted"],2)),row.names=F,quote=F,file=sprintf("pdbbind-%s-%s-iyp.csv",v,t)) # Write the measured binding affinities and the predicted ones in CSV format.
