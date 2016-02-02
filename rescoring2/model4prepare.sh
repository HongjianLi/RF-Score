pdbbind=~/PDBbind
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
for m in 2 3 4; do
	cd model$m
	echo model$m
	for s in 1 2; do
		cd set$s
		echo set$s
		for vi in {0..4}; do
			for trn in {0..6}; do
				if [[ $vi == 0 ]]; then
					echo tst-$trn-yxi.csv
					rf-prepare $pdbbind/v${v[$s,$vi]}/rescoring-2-set-$s-tst-iy.csv $m $trn > tst-$trn-yxi.csv
				else
					echo pdbbind-${v[$s,$vi]}-trn-$trn-yxi.csv
					rf-prepare $pdbbind/v${v[$s,$vi]}/rescoring-2-set-$s-trn-iy.csv $m $trn > pdbbind-${v[$s,$vi]}-trn-$trn-yxi.csv
				fi
			done
		done
		cd ..
	done
	cd ..
done
