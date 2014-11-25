pdbbind=~/PDBbind
v=(2013 2012)
for m in 2 3 4; do
	cd model$m
	echo model$m
	[[ $m == 4 ]] && p=36 || p=0
	p=$((p+6))
	q=$((p+6))
	for s in 2; do
		cd set$s
		echo set$s
		for vi in {0..1}; do
			if [[ $vi == 0 ]]; then
				echo tst-yxi.csv
				rf-prepare $pdbbind/v${v[$vi]}/rescoring-4-set-$s-tst-iy.csv $m | cut -d, -f1-$p,$q- | sed 's/_inter//g' > tst-yxi.csv
			else
				for trn in {0..7}; do
					echo pdbbind-${v[$vi]}-trn-$trn-yxi.csv
					rf-prepare $pdbbind/v${v[$vi]}/rescoring-4-set-$s-trn-$trn-iy.csv $m | cut -d, -f1-$p,$q- | sed 's/_inter//g' > pdbbind-${v[$vi]}-trn-$trn-yxi.csv
				done
			fi
		done
		cd ..
	done
	cd ..
done
