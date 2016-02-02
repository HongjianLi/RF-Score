# Rescoring models 2

Several models for ranking protein-ligand complexes according to predicted binding affinity in the presence of pose generation error are evaluated and compared on six schemes of two datasets.

## Models

### Model 1

Vina

### Model 2

MLR::Vina

### Model 3

RF::Vina

### Model 4

RF::VinaElem

## Datasets

### Dataset 1

The test set 0) and the four training sets 1), 2), 3), 4) are as follows:

0) PDBbind v2007 core set (N = 195). This test set is the one used in [DOI: 10.1021/ci9000053]. Therefore it has N = 195.

1) PDBbind v2004 refined set (N = 1091) minus PDBbind v2007 core set (N = 195). Both sets have 138 complexes in common. The 1oko protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. Therefore this training set has N = 1091 - 138 - 1 = 952 complexes.

2) PDBbind v2007 refined set (N = 1300) minus PDBbind v2007 core set (N = 195). This training set is the one used in [DOI: 10.1021/ci9000053]. Therefore it has N = 1105. Note that every complex in the test set has complexes involving the same protein in this training set.

3) PDBbind v2010 refined set (N = 2061) minus PDBbind v2007 core set (N = 195). Both sets have 182 complexes in common. The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. The 2rio protein contains Sr atoms and the 2ov4 protein contains Cs atoms, which cannot be recognized by Vina. Therefore this training set has N = 2061 - 182 - 4 = 1875 complexes.

4) PDBbind v2013 refined set (N = 2959) minus PDBbind v2007 core set (N = 195). Both sets have 165 complexes in common. The 2rio protein contains Sr atoms and the 3rv4 protein contains Cs atoms, which cannot be recognized by Vina. Therefore this training set has N = 2959 - 165 - 2 = 2792 complexes.

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
* |3 ∩ 4| = 1673

### Dataset 2

The test set 0) and the four training sets 1), 2), 3), 4) are as follows:

0) PDBbind v2013 refined set (N = 2959) minus PDBbind v2012 refined set (N = 2897). Both sets have 2576 complexes in common. The 3rv4 protein consists of two Cs atoms which Vina does not support. Therefore this test set has N = 2959 - 2576 - 1 = 382 complexes.

1) PDBbind v2002 refined set (N = 800). The 1tha protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1lkk, 1mfi, 7std, 1cet, 2std, 1els, 1c3x ligands fail PDB-to-PDBQT conversion by prepare_ligand4.py. Therefore this training set has N = 800 - 8 = 792 complexes. Note that in 584 \*\_protein.pdbqt's (e.g. 1gvu, 1bxo) the Ho atom type is incorrectly assigned to the HOCA atom, which is a polar hydrogen atom bonded to the OXT atom of the last residue. Therefore these \*\_protein.pdbqt's are curated by sed 's/Ho/HD/g' in batch. Also note that in 39 \*\_ligand.mol2's (e.g. 1cil, 1duv) the x, y, z coordinates are of 14.8 format instead of the official 10.4 format.

2) PDBbind v2007 refined set (N = 1300). This training set has N = 1300 complexes.

3) PDBbind v2010 refined set (N = 2061). The 2bo4 protein fails PDB-to-PDBQT conversion by prepare_receptor4.py. The 1xr8 ligand is far away from its protein. The 2rio protein contains Sr atoms and the 2ov4 protein contains Cs atoms, which cannot be recognized by Vina. Therefore this training set has N = 2061 - 4 = 2057 complexes.

4) PDBbind v2012 refined set (N = 2897). This training set has N = 2897 complexes.

Their intersections are as follows:

* |0 ∩ 1| = 0
* |0 ∩ 2| = 0
* |0 ∩ 3| = 0
* |0 ∩ 4| = 0
* |1 ∩ 2| = 592
* |1 ∩ 3| = 536
* |1 ∩ 4| = 565
* |2 ∩ 3| = 1178
* |2 ∩ 4| = 1173
* |3 ∩ 4| = 2030

## Schemes

In the schemes below, different poses are chosen to calculate the features.

### Scheme 0

The chosen pose is the docked pose with the largest RMSD.

### Scheme 1

The chosen pose is the crystal pose.

### Scheme 2

The chosen pose is the docked pose with the lowest Vina score.

### Scheme 3

The chosen pose is the docked pose with the lowest RMSD.

### Scheme 4

The chosen pose is the docked pose with a Vina score closest to the measured binding affinity of that complex.

### Scheme 5

The chosen poses are all the 9 docked poses. If a structure produces less than 9 docked poses, the features of the pose with the lowest Vina score are repeated, e.g. 1 + 1 + 1 + 2 + 3 + 4 + 5 + 6 + 7. Therefore there are 10 * 9 + 1 = 91 features for model 2 and 3, and (36 + 10) * 9 + 1 = 415 features for model 4.

### Scheme 6

The chosen poses are the 2 docked poses with the lowest and the second lowest Vina score. If a structure produces less than 2 docked poses, the features of the pose with the lowest Vina score are repeated, e.g. 1 + 1. Therefore there are 10 * 2 + 1 = 21 features for models 2 and 3, and (36 + 10) * 2 + 1 = 93 features for model 4.

## Experiments

By combining the 4 models and the 6 schemes, 32 combinations are evaluated:

* 1 models (1) \* 1 training schemes (1) \* 2 test schemes (1, 2) = 2 combinations
* 3 models (2, 3, 4) \* 4 training schemes (0, 1, 2, 3, 4) \* 2 test schemes (1, 2) = 30 combinations
* 3 models (2, 3, 4) \* 1 training schemes (5) \* 1 test schemes (5) = 3 combinations
* 3 models (2, 3, 4) \* 1 training schemes (6) \* 1 test schemes (6) = 3 combinations

There are 8 training-test set partitions in the 2 datasets, so altogether there are 32 * 8 = 256 sets of performance measures.

For model 2, the sampling range for wNrot is extended to [0.000 to 0.030] with a step size of 0.001 because of more variability in the 6 schemes.

For models 3 and 4, the mtry values are exhausted from 1 to the number of features.

## Files

The folders and files are organized hierarchically. Model-specific files are in the model{1,2,3,4} folders. Cross-model files are in the set{1,2} folders.

For data files, their nomenclature are as follows:

* i means PDB ID
* y means measured pKd
* p means predicted pKd
* d means RMSD

For example,

* `set1/tst-1-iy.csv` means the [PDB,pbindaff] file of the test set in scheme 1 of dataset 1, i.e. the PDB ID and measured pKd of the crystal poses of PDBbind v2007 core set.
* `set1/tst-2-id.csv` means the [PDB,RMSD1] file of the test set in scheme 2 of dataset 1, i.e. the PDB ID and RMSD of the docked pose with the lowest Vina score of PDBbind v2007 core set.
* `model3/set1/89757/pdbbind-2007-trn-3-tst-2-iyp.csv` means the [PDB,pbindaff,predicted] file of model 3 on dataset 1 and PDBbind v2007 trained in scheme 3 with seed 89757 and tested in scheme 2.
* `model3/set1/pdbbind-2007-trn-4-tst-1-stat.csv` means the [seed,n,rmse,sdev,pcor,scor,kcor] file of model 3 on dataset 1 and PDBbind v2007 trained in scheme 4 and tested in scheme 1, over all seeds.
* `model3/set1/tst-stat.csv` means the [v,trn,tst,w,n,rmse,sdev,pcor,scor,kcor] file of model 3 on dataset 1, over all PDBbind versions, all training schemes and all test schemes. For each [v,trn,tst] combination, only the best seed for models 3 and 4 or the best weight for model 2 is shown in the w column.

For script files, their functions and execution orders are as follows:

* `pdbbind.sh` does file format conversion, binding site detection, docking by Vina, RMSD computation, and finding the corresponding pose in schemes 1, 2, 3, 4, all in the PDBbind folder.
* `duplicates.sh` computes the number of duplicate complexes between training sets and test set and among training sets in each of the 2 datasets.
* `model1prepare.sh` generates model1/set{1,2}/pdbbind-2007-trn-1-tst-{1,2}-iyp.csv.
* `model4prepare.sh` generates model{2,3,4}/set{1,2}/{tst-{1,2,3,4,5,6}-yxi.csv,pdbbind-$v-trn-{1,2,3,4,5,6}-yxi.csv}.
* `model1.sh` tests model 1 and generates model1/set{1,2}/pdbbind-2007-trn-1-tst-{1,2}-stat.csv.
* `model2.sh` trains and tests model 2 with a grid search of wNrot in [0.000 to 0.030] with a step size of 0.001, and generates model2/set{1,2}/tst-stat.csv.
* `model3.sh` trains and tests models 3 and 4 with 10 seeds, and generates model{3,4}/set{1,2}/tst-stat.csv.
* `maxerr.sh` finds the top 10 complexes with the largest absolute error between measured pKd and model 1 pKd and between measured pKd and model 4 pKd in test schemes 1 and 2. Its output is saved to maxerr.csv.
* `rmsd.sh` computes RMSD relevant statistics.
* `model2train.R` trains model 2 on model2/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-yxi.csv using multiple linear regression, and writes the intercept and coefficients to model2/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-coef.csv.
* `model2test.R` tests model 2 on model2/set{1,2}/tst-{1,2}-yxi.csv, and writes the statistics to model2/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2}-stat.csv.
* `iypplot.R` writes models{1,2,3,4}/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2}-{iyp,stat}.csv and plots models{1,2,3,4}/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2}-yp.tiff.
* `idpplot.R` plots models{1,2,3,4}/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2}-dp.tiff.
* `varImpPlot.R` plots models{3,4}/set{1,2}/$w/pdbbind-$v-trn-{1,2,3,4,5,6}-varimpplot.tiff.
* `statplot.R` plots model{2,3,4}/set{1,2}/trn-{1,2,3,4,5,6}-tst-{1,2,5,6}-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff, set{1,2}/pdbbind-$v-trn-{1,2,3,4,5,6}-tst-{1,2,5,6}-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff, set{1,2}/trn-{1,2,3,4,5,6}-tst-{1,2,5,6}-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff, and set{1,2}/pdbbind-2007-trn-{1,2,3,4}-{rmse,sdev,pcor,scor,kcor}-{boxplot,median}.tiff. This R script is self contained and requires no command line arguments. It is not called in any bash scripts and therefore should be called in the end.
* `model2testp.R` tests model 2 on docked poses, and writes predicted pKd values to standard output. This R script is called by `rmsd.sh`.

## Results

The test sets in datasets 1 and 2 are docked by Vina. Let RMSDi denote the RMSD between the docked pose with the ith (i=0,1,...,9) best model score and the crystal pose, and RMSDm=min(RMSD1,RMSD2,...,RMSD9).

### Rescoring docked poses on dataset 1

For model 1 trained on PDBbind v2007 in scheme 1

* |RMSD1 < 0.5| = 26
* |RMSD1 < 1.0| = 60
* |RMSD1 < 1.5| = 86
* |RMSD1 < 2.0| = 101
* |RMSD1 < 2.5| = 111
* |RMSD1 < 3.0| = 116
* |RMSDm < 0.5| = 27
* |RMSDm < 1.0| = 73
* |RMSDm < 1.5| = 121
* |RMSDm < 2.0| = 149
* |RMSDm < 2.5| = 162
* |RMSDm < 3.0| = 170

Therefore, the number of complexes where the pose with the lowest Vina score has RMSD < 2.0 is 101 (101 / 195 = 52%).

The numbers of complexes whose docked pose with the ith (i=0,1,...,9) best model score has the lowest RMSD are as follows:

For model 1 trained on PDBbind v2007 in scheme 1

* |RMSD1 = RMSDm| = 94
* |RMSD2 = RMSDm| = 27
* |RMSD3 = RMSDm| = 13
* |RMSD4 = RMSDm| = 13
* |RMSD5 = RMSDm| = 10
* |RMSD6 = RMSDm| = 11
* |RMSD7 = RMSDm| = 14
* |RMSD8 = RMSDm| = 6
* |RMSD9 = RMSDm| = 7

Therefore, the % of complexes where the pose with the best model 1 score also has the lowest RMSD is 94 / 195 = 48%.

For model 2 trained on PDBbind v2007 in scheme 1 using the best weight 0.010

* |RMSD1 = RMSDm| = 59
* |RMSD2 = RMSDm| = 32
* |RMSD3 = RMSDm| = 16
* |RMSD4 = RMSDm| = 21
* |RMSD5 = RMSDm| = 21
* |RMSD6 = RMSDm| = 12
* |RMSD7 = RMSDm| = 8
* |RMSD8 = RMSDm| = 13
* |RMSD9 = RMSDm| = 13

Therefore, the % of complexes where the pose with the best model 2 score also has the lowest RMSD is 59 / 195 = 30%.

For model 3 trained on PDBbind v2007 in scheme 1 using the best seed 99789

* |RMSD1 = RMSDm| = 53
* |RMSD2 = RMSDm| = 32
* |RMSD3 = RMSDm| = 20
* |RMSD4 = RMSDm| = 15
* |RMSD5 = RMSDm| = 16
* |RMSD6 = RMSDm| = 16
* |RMSD7 = RMSDm| = 12
* |RMSD8 = RMSDm| = 13
* |RMSD9 = RMSDm| = 18

Therefore, the % of complexes where the pose with the best model 3 score also has the lowest RMSD is 53 / 195 = 27%.

For model 4 trained on PDBbind v2007 in scheme 1 using the best seed 52857

* |RMSD1 = RMSDm| = 59
* |RMSD2 = RMSDm| = 40
* |RMSD3 = RMSDm| = 16
* |RMSD4 = RMSDm| = 14
* |RMSD5 = RMSDm| = 10
* |RMSD6 = RMSDm| = 21
* |RMSD7 = RMSDm| = 12
* |RMSD8 = RMSDm| = 15
* |RMSD9 = RMSDm| = 8

Therefore, the % of complexes where the pose with the best model 4 score also has the lowest RMSD is 59 / 195 = 30%.

### Rescoring docked poses on dataset 2

For model 1 trained on PDBbind v2007 in scheme 1

* |RMSD1 < 0.5| = 54
* |RMSD1 < 1.0| = 135
* |RMSD1 < 1.5| = 188
* |RMSD1 < 2.0| = 219
* |RMSD1 < 2.5| = 236
* |RMSD1 < 3.0| = 255
* |RMSDm < 0.5| = 60
* |RMSDm < 1.0| = 168
* |RMSDm < 1.5| = 265
* |RMSDm < 2.0| = 311
* |RMSDm < 2.5| = 327
* |RMSDm < 3.0| = 339

Therefore, the number of complexes where the pose with the lowest Vina score has RMSD < 2.0 is 219 (219 / 382 = 57%).

The numbers of complexes whose docked pose with the ith (i=0,1,...,9) best model score has the lowest RMSD are as follows:

For model 1 trained on PDBbind v2007 in scheme 1

* |RMSD1 = RMSDm| = 208
* |RMSD2 = RMSDm| = 52
* |RMSD3 = RMSDm| = 34
* |RMSD4 = RMSDm| = 17
* |RMSD5 = RMSDm| = 19
* |RMSD6 = RMSDm| = 13
* |RMSD7 = RMSDm| = 16
* |RMSD8 = RMSDm| = 9
* |RMSD9 = RMSDm| = 14

Therefore, the % of complexes where the pose with the best model 1 score also has the lowest RMSD is 208 / 382 = 54%.

For model 2 trained on PDBbind v2007 in scheme 1 using the best weight 0.011

* |RMSD1 = RMSDm| = 142
* |RMSD2 = RMSDm| = 80
* |RMSD3 = RMSDm| = 39
* |RMSD4 = RMSDm| = 40
* |RMSD5 = RMSDm| = 19
* |RMSD6 = RMSDm| = 22
* |RMSD7 = RMSDm| = 14
* |RMSD8 = RMSDm| = 12
* |RMSD9 = RMSDm| = 14

Therefore, the % of complexes where the pose with the best model 2 score also has the lowest RMSD is 142 / 382 = 37%.

For model 3 trained on PDBbind v2007 in scheme 1 using the best seed 72551

* |RMSD1 = RMSDm| = 119
* |RMSD2 = RMSDm| = 58
* |RMSD3 = RMSDm| = 42
* |RMSD4 = RMSDm| = 44
* |RMSD5 = RMSDm| = 31
* |RMSD6 = RMSDm| = 28
* |RMSD7 = RMSDm| = 26
* |RMSD8 = RMSDm| = 22
* |RMSD9 = RMSDm| = 12

Therefore, the % of complexes where the pose with the best model 3 score also has the lowest RMSD is 119 / 382 = 31%.

For model 4 trained on PDBbind v2007 in scheme 1 using the best seed 72551

* |RMSD1 = RMSDm| = 141
* |RMSD2 = RMSDm| = 57
* |RMSD3 = RMSDm| = 52
* |RMSD4 = RMSDm| = 32
* |RMSD5 = RMSDm| = 26
* |RMSD6 = RMSDm| = 18
* |RMSD7 = RMSDm| = 20
* |RMSD8 = RMSDm| = 20
* |RMSD9 = RMSDm| = 16

Therefore, the % of complexes where the pose with the best model 4 score also has the lowest RMSD is 141 / 382 = 37%.

[DOI: 10.1021/ci9000053]: http://dx.doi.org/10.1021/ci9000053
