pdbbind=~/PDBbind
nv=(0 4 5 2)
declare -A v
v[1,0]=2007
v[1,1]=2004
v[1,2]=2007
v[1,3]=2010
v[1,4]=2013
v[2,0]=2013
v[2,1]=2002
v[2,2]=2007
v[2,3]=2010
v[2,4]=2012
v[2,5]=2014
v[3,0]=2013
v[3,1]=2013
v[3,2]=2014
for m in 0; do
	cd model$m
	echo model$m
	for s in 1 2 3; do
		cd set$s
		echo set$s
		for vi in $(seq 0 ${nv[$s]}); do
			vt=${v[$s,$vi]}
			if [[ $vi == 0 ]]; then
				echo tst-yxi.csv
				echo pbindaff,nha,mwt,PDB > tst-yxi.csv
				for iy in $(< $pdbbind/v$vt/rescoring-1-set-$s-tst-iy.csv); do
					c=${iy:0:4}
					y=${iy:5}
					echo $y,$(~/zinc/utilities/countmwt < ~/PDBbind/v$vt/$c/${c}_ligand.pdbqt),$c
				done >> tst-yxi.csv
			else
				echo pdbbind-$vt-trn-yxi.csv
				echo pbindaff,nha,mwt,PDB > pdbbind-$vt-trn-yxi.csv
				for iy in $(< $pdbbind/v$vt/rescoring-1-set-$s-trn-iy.csv); do
					c=${iy:0:4}
					y=${iy:5}
					echo $y,$(~/zinc/utilities/countmwt < ~/PDBbind/v$vt/$c/${c}_ligand.pdbqt),$c
				done >> pdbbind-$vt-trn-yxi.csv
			fi
		done
		cd ..
	done
	cd ..
done

