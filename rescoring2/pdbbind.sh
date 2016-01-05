for v in 2002 2004 2007 2010 2012 2013; do
	cd v$v
	for iy in $(cat pdbbind-$v-refined-iy.csv); do
		c=${iy:0:4}
		echo $v $c
		cd $c
		python2.5 ${MGLTOOLS_ROOT}/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.pyo -U waters -r ${c}_protein.pdb
		python2.5 ${MGLTOOLS_ROOT}/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.pyo -U '' -l ${c}_ligand.mol2
		~/PDBbind/definebox/bin/definebox ${c}_ligand.mol2 > box.conf
		mkdir -p log out
		vina --config box.conf --receptor ${c}_protein.pdbqt --ligand ${c}_ligand.pdbqt --log log/${c}_ligand.txt --out out/${c}_ligand.pdbqt
		rmsdpdbqt ${c}_ligand.pdbqt out/${c}_ligand.pdbqt > vina.rmsd
		vina_split --input out/${c}_ligand.pdbqt
		echo 0 > vina-scheme-1.txt
		echo 1 > vina-scheme-2.txt
		n=$(wc -l < vina.rmsd)
		echo $n > out/conformation_count.txt
		paste ../../seq$n vina.rmsd | sort -s -k2,2n | head -1 | cut -f1 > vina-scheme-3.txt
		w=$(grep "WARNING" log/${c}_ligand.txt | wc -l)
		tail -n +$((26+$w)) log/${c}_ligand.txt | head -$n | awk -v y=$(cat pbindaff.txt) 'function abs(x){return x < 0 ? -x : x} {print abs(substr($0,13,5) * -0.73349480509 - y)}' | paste ../../seq$n - | sort -s -k2,2n | head -1 | cut -f1 > vina-scheme-4.txt
		ln -s ../${c}_ligand.pdbqt out/${c}_ligand_ligand_0.pdbqt
		for i in {0..1}; do
			vina --receptor ${c}_protein.pdbqt --ligand out/${c}_ligand_ligand_${i}.pdbqt --score_only > out/${c}_ligand_ligand_${i}.txt
		done
		cd ..
	done
	cd ..
done
