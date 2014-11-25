# Rescoring models

Several models for rescoring protein-ligand binding affinity are evaluated and compared in terms of prediction performance on four datasets, each of which consists of some training sets and one test set. For each of the datasets, the test set has no overlapping complexes in any of the training sets.

## Models

### Model 0 is a linear regression using number of heavy atoms (NHA) or molecular weight (MWT) of the ligand as the only feature.

Model 0

### Model 1

Model 1 is the Vina score, whose parameters are tuned by nonlinear optimization on PDBbind v2007 refined set (N = 1300). Its functional form is e = (w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding) / (1 + w6*Nrot), where e is free energy in kcal/mol and w = [-0.035579,-0.005156,0.840245,-0.035069,-0.587439,0.05846] and cutoff = 8A. Vina identifies inactive torsions (i.e. -OH, -NH2, -CH3) and active torsions (i.e. other than the 3 types), and implements Nrot = N(ActTors) + 0.5*N(InactTors), i.e. active torsions are counted as 1 while inactive torsions are counted as 0.5. The free energy in kcal/mol is converted to binding affinity in pKd by multiplying -0.73349480509.

### Model 2

Model 2 is a multiple linear regression model with the same functional form and cutoff as the Vina score. The denominator (1 + w6*Nrot) is moved to the left hand side, transforming the equation into z = e * (1 + w6*Nrot) = w1*gauss1 + w2*gauss2 + w3*repulsion + w4*hydrophobic + w5*hydrogenbonding. To find the optimal value of w6, 16 values are sampled from 0.005 to 0.020 with a step size of 0.001. The range [0.005, 0.020] is chosen because the optimal value of w6 always falls in it for all the eight training sets of the two datasets.

### Model 3

Model 3 is a random forest of 500 trees using 6 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic, hydrogenbonding and Nrot. It is separately trained on the same four training sets as in model 2 and each with 10 different seeds, i.e. 89757,35577,51105,72551,10642,69834,47945,52857,26894,99789. For a given seed, 6 random forests are trained with mtry = 1 to 6, and the one with the minimum RMSE(OOB) is chosen.

### Model 4

Model 4 is the same as model 3, except that it uses 36 RF-Score features and 6 Vina features. For a given seed, 42 random forests are trained with mtry = 1 to 42, and the one with the minimum RMSE(OOB) is chosen.

### Model 5

Model 5 is the same as model 3, except that it uses 5 Vina features, i.e. gauss1, gauss2, repulsion, hydrophobic and hydrogenbonding. For a given seed, 5 random forests are trained with mtry = 1 to 5, and the one with the minimum RMSE(OOB) is chosen.

## Datasets

### Dataset 1

The test set 0) and the training sets 1), 2), 3), 4) are as follows:

0) PDBbind v2007 core set (N = 195). This test set is the one used in [DOI: 10.1021/ci9000053]. Therefore it has N = 195.

1) PDBbind v2004 refined set (N = 1091) minus PDBbind v2007 core set (N = 195). Both sets have 138 complexes in common. The 1oko protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. Therefore this training set has N = 1091 - 138 - 1 = 952 complexes.

2) PDBbind v2007 refined set (N = 1300) minus PDBbind v2007 core set (N = 195). This training set is the one used in [DOI: 10.1021/ci9000053]. Therefore it has N = 1105. Note that every complex in the test set has complexes involving the same protein in this training set.

3) PDBbind v2010 refined set (N = 2061) minus PDBbind v2007 core set (N = 195). Both sets have 182 complexes in common. The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. Therefore this training set has N = 2061 - 182 - 2 = 1877 complexes.

4) PDBbind v2013 refined set (N = 2959) minus PDBbind v2007 core set (N = 195). Both sets have 165 complexes in common. Therefore this training set has N = 2959 - 165 = 2794 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0
* |0 ∩ 2| = 0
* |0 ∩ 3| = 0
* |0 ∩ 4| = 0
* |1 ∩ 2| = 786
* |1 ∩ 3| = 707
* |1 ∩ 4| = 695
* |2 ∩ 3| = 996
* |2 ∩ 4| = 909
* |3 ∩ 4| = 1675

### Dataset 2

The test set 0) and the training sets 1), 2), 3), 4), 5) are as follows:

0) PDBbind v2013 refined set (N = 2959) minus PDBbind v2012 refined set (N = 2897). Both sets have 2576 complexes in common. The 3rv4 protein consists of two Cs atoms which Vina does not support. Therefore this test set has N = 2959 - 2576 - 1 = 382 complexes.

1) PDBbind v2002 refined set (N = 800). The 1tha protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1lkk, 1mfi, 7std, 1cet, 2std, 1els, 1c3x ligands fail PDB-to-PDBQT conversion by prepare_ligand4.py. Therefore this training set has N = 800 - 8 = 792 complexes.

2) PDBbind v2007 refined set (N = 1300). This training set has N = 1300 complexes.

3) PDBbind v2010 refined set (N = 2061). The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. Therefore this training set has N = 2061 - 2 = 2059 complexes.

4) PDBbind v2012 refined set (N = 2897). This training set has N = 2897 complexes.

5) PDBbind v2014 refined set (N = 3446) minus the test set 0). The 4bps and 2iw4 proteins fail PDB-to-PDBQT conversion by prepare_receptor4.py. Both sets have 368 complexes in common. Therefore this training set has N = 3446 - 2 - 368 = 3076 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0
* |0 ∩ 2| = 0
* |0 ∩ 3| = 0
* |0 ∩ 4| = 0
* |0 ∩ 5| = 0
* |1 ∩ 2| = 592
* |1 ∩ 3| = 536
* |1 ∩ 4| = 565
* |1 ∩ 5| = 527
* |2 ∩ 3| = 1178
* |2 ∩ 4| = 1173
* |2 ∩ 5| = 1061
* |3 ∩ 4| = 2032
* |3 ∩ 5| = 1814
* |4 ∩ 5| = 2529

### Dataset 3

The test set 0) and the training sets 1), 2) are as follows:

0) PDBbind v2013 core set (N = 195).

1) PDBbind v2013 refined set (N = 2959) minus PDBbind v2013 core set (N = 195). Therefore this training set has N = 2959 - 195 = 2764 complexes.

2) PDBbind v2014 refined set (N = 3446) minus PDBbind v2013 core set (N = 195). The 4bps and 2iw4 proteins fail PDB-to-PDBQT conversion by prepare_receptor4.py. Both sets have 195 complexes in common. Therefore this training set has N = 3446 - 2 - 195 = 3249 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0
* |0 ∩ 2| = 0
* |1 ∩ 2| = 2703

### Dataset 4

The test set 0) and the training set 1) are as follows:

0) PDBbind v2014 refined set (N = 3446) minus PDBbind v2013 refined set (N = 2959). The 3rv4 protein consists of two Cs atoms which Vina does not support. Both sets have 2898 complexes in common. Therefore this test set has N = 3446 - 2 - 2898 - 1 = 546 complexes.

1) PDBbind v2013 refined set (N = 2959). This training set has N = 2897 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0

## Files

The folders and files are organized hierarchically. Model-specific files are in the model{1,2,3,4} folders. Cross-model files are in the set{1,2,3} folders.

For data files, their nomenclature are as follows:

* i means PDB ID
* y means measured pKd
* p means predicted pKd

For example,

* `set1/tst-iy.csv` means the [PDB,pbindaff] file of the test set of dataset 1, i.e. the PDB ID and measured pKd of PDBbind v2007 core set.
* `model3/set1/89757/pdbbind-2007-tst-iyp.csv` means the [PDB,pbindaff,predicted] file of model 3 on dataset 1 trained on the PDBbind v2007 training set with seed 89757 and tested on the test set.
* `model3/set1/pdbbind-2007-tst-stat.csv` means the [seed,n,rmse,sdev,pcor,scor,kcor] file of model 3 on dataset 1 trained on the PDBbind v2007 training set and tested on the test set, over all seeds.
* `model3/set1/tst-stat.csv` means the [v,w,n,rmse,sdev,pcor,scor,kcor] file of model 3 on dataset 1, over all PDBbind versions. For each v, only the best seed for models 3 and 4 or the best weight for model 2 is shown in the w column.

For script files, their functions and execution orders are as follows:

* `duplicates.sh` computes the number of duplicate complexes between training sets and test set and among training sets in each of the datasets.
* `model0prepare.sh` generates model0/set{1,2,3}/{tst-yxi,pdbbind-$v-trn-yxi}.csv.
* `model1prepare.sh` generates model1/set{1,2,3}/pdbbind-2007-{trn,tst}-iyp.csv.
* `model4prepare.sh` generates model{2,3,4,5}/set{1,2,3}/{tst-yxi,pdbbind-$v-trn-yxi}.csv.
* `model0.sh` trains and tests model 0, and generates model0/set{1,2,3}/$w/pdbbind-$vtst-stat.csv.
* `model1.sh` tests model 1 and generates model1/set{1,2,3}/pdbbind-2007-{trn,tst}-stat.csv.
* `model2.sh` trains and tests model 2 with a grid search of wNrot in [0.005 to 0.020] with a step size of 0.001, and generates model2/set{1,2,3}/tst-stat.csv.
* `model3.sh` trains and tests models 3 and 4 with 10 seeds, and generates model{3,4}/set{1,2,3}/tst-stat.csv.
* `maxerr.sh` finds the top 10 complexes with the largest absolute error between measured pKd and model 1 pKd and between measured pKd and model 4 pKd. Its output is saved to maxerr.csv.
* `model0train.R` trains model 0 on model0/set{1,2,3}/pdbbind-$v-trn-yxi.csv using linear regression with NHA or MWT, and writes the intercept and coefficients to model0/set{1,2,3}/$w/pdbbind-$v.csv.
* `model0test.R` tests model 0 on model0/set{1,2,3}/tst-yxi.csv, and writes the statistics to model0/set{1,2,3}/$w/pdbbind-$v-tst-stat.csv.
* `model2train.R` trains model 2 on model2/set{1,2,3}/$w/pdbbind-$v-trn-yxi.csv using multiple linear regression, and writes the intercept and coefficients to model2/set{1,2,3}/$w/pdbbind-$v.csv.
* `model2test.R` tests model 2 on model2/set{1,2,3}/tst-yxi.csv, and writes the statistics to model2/set{1,2,3}/$w/pdbbind-$v-tst-stat.csv.
* `iypplot.R` writes models{0,1,2,3,4,5}/set{1,2,3}/$w/pdbbind-$v-{trn,tst}-stat.csv and plots models{0,1,2,3,4,5}/set{1,2,3}/$w/pdbbind-$v-{trn,tst}-yp.tiff.
* `varImpPlot.R` plots models{3,4,5}/set{1,2,3}/$w/pdbbind-$v-trn-varimpplot.tiff.
* `statplot.R` plots model{2,3,4,5}/set{1,2,3}/tst-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff, set{1,2,3}/pdbbind-$v-tst-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff, set{1,2,3}/tst-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff. This R script is self contained and requires no command line arguments. It is not called in any bash scripts and therefore should be called in the end.

[DOI: 10.1021/ci9000053]: http://dx.doi.org/10.1021/ci9000053
