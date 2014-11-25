### The general set has 9308 structures, including protein-ligand, protein-protein, protein-DNA, DNA-ligand complexes.
* 9308 -> 7074: Only protein-ligand structures are provided in the downloaded pdbbind_v2012.tar.gz.
* 7074 -> 7072: 2 ligands (2iw4, 3gpj) failing PDB-to-PDBQT conversion were removed.
* 7072 -> 6973: 99 inexact binding affinity data containing <>~ were removed, e.g. Kd<=100uM, Ki~0.1pm. trn-7
* 6973 -> 6881: 92 NMR structures were removed. trn-6

### IC50 binding affinity data retained
* 6881 -> 6719: Structures with resolution <= 3.0Å were retained. trn-5
* 6719 -> 5752: Structures with resolution <= 2.5Å were retained. trn-4

### IC50 binding affinity data removed
* 6881 -> 4449: 2432 IC50 binding affinity data were removed. trn-3
* 4449 -> 4356: Structures with resolution <= 3.0Å were retained. trn-2
* 4356 -> 3809: Structures with resolution <= 2.5Å were retained. trn-1

* 2897: Structures in the refined set. trn-0
