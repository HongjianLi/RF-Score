pdbbind=~/PDBbind
for m in 1; do
	cd model$m
	echo model$m
	for s in 1 2 3; do
		cd set$s
		echo set$s
		for t in trn tst; do
			echo PDB,pbindaff,predicted > pdbbind-2007-$t-iyp.csv
			v=$([[ $s == 1 || ($s == 2 && $t == "trn") ]] && echo 2007 || echo 2013)
			for c in $(cut -d, -f1 $pdbbind/v$v/rescoring-1-set-$s-$t-iy.csv); do
				tail -n +18 $pdbbind/v$v/${c}/out/${c}_ligand_ligand_0.txt | head -1
			done | cut -d' ' -f2 | awk '{printf "%.2f\n", $1*-0.73349480509}' | paste -d, $t-iy.csv - >> pdbbind-2007-$t-iyp.csv
		done
		cd ..
	done
	cd ..
done
