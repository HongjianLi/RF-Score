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
for m in 2 3 4; do
	cd model$m
	echo model$m
	[[ $m == 4 ]] && p=36 || p=0
	p=$((p+6))
	q=$((p+6))
	for s in 1 2 3; do
		cd set$s
		echo set$s
		for vi in $(seq 0 ${nv[$s]}); do
			if [[ $vi == 0 ]]; then
				echo tst-yxi.csv
				rf-prepare $pdbbind/v${v[$s,$vi]}/rescoring-1-set-$s-tst-iy.csv $m | cut -d, -f1-$p,$q- | sed 's/_inter//g' > tst-yxi.csv
			else
				echo pdbbind-${v[$s,$vi]}-trn-yxi.csv
				rf-prepare $pdbbind/v${v[$s,$vi]}/rescoring-1-set-$s-trn-iy.csv $m | cut -d, -f1-$p,$q- | sed 's/_inter//g' > pdbbind-${v[$s,$vi]}-trn-yxi.csv
			fi
		done
		cd ..
	done
	cd ..
done
for m in 5; do
	cd model$m
	echo model$m
	for s in 1 2 3; do
		cd set$s
		echo set$s
		for vi in $(seq 0 ${nv[$s]}); do
			if [[ $vi == 0 ]]; then
				echo tst-yxi.csv
				cut -d, -f1-6,8 ../../model3/set$s/tst-yxi.csv > tst-yxi.csv
			else
				echo pdbbind-${v[$s,$vi]}-trn-yxi.csv
				cut -d, -f1-6,8 ../../model3/set$s/pdbbind-${v[$s,$vi]}-trn-yxi.csv > pdbbind-${v[$s,$vi]}-trn-yxi.csv
			fi
		done
		cd ..
	done
	cd ..
done
