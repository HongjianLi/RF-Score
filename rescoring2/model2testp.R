#!/usr/bin/env Rscript
args=commandArgs(trailingOnly=T)
f=args[1] # e.g. model2/set1/0.015/pdbbind-2007-trn-1-coef.csv
w=as.numeric(args[2]) # 0.015
c=read.csv(f)[,2]
d=read.csv(file("stdin"))
d["t"]=1+w*(d["nacttors"]+0.5*d["ninacttors"]) # Flexibility penalty = 1 + w * Nrot. In Vina's implementation, active torsions are counted as 1, while inactive torsions (i.e. -OH,-NH2,-CH3) are counted as 0.5.
d["predicted"]=(c[1]+c[2]*d[1]+c[3]*d[2]+c[4]*d[3]+c[5]*d[4]+c[6]*d[5]+c[7]*d[6]+c[8]*d[7]+c[9]*d[8]+c[10]*d[9]+c[11]*d[10])/d["t"] # Binding affinity predicted by the newly-trained model, with kcal/mol converted to pKd.
write.table(round(d["predicted"],3),sep=",",col.names=F,row.names=F,quote=F) # Write the measured binding affinities and the predicted ones in CSV format.
