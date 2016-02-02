for m in 2; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		for trn in {0..6}; do
			echo trn$trn
			if [[ $trn -ge 5 ]]; then
				tsts=$(seq $trn $trn)
			else
				tsts=$(seq 1 2)
			fi
			for v in $(ls -1 pdbbind-*-trn-$trn-yxi.csv | cut -d- -f2); do
				echo $v
				echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-trn-$trn-stat.csv
				for tst in $tsts; do
					echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
				for w in $(seq 0.000 0.001 0.030); do
					echo $w
					mkdir -p $w
					cd $w
					../../../model2train.R $v $trn $w
					../../../model2test.R $v $trn 0 $w trn
					tail -n +2 pdbbind-$v-trn-$trn-trn-$trn-iyp.csv | cut -d, -f2,3 | rf-stat > pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					for tst in $tsts; do
						../../../model2test.R $v $trn $tst $w tst
						../../../iypplot.R $v $trn $tst
					done
					if [[ $trn -lt 5 ]]; then
						../../../idpplot.R $v $trn 2 $s
					fi
					cd ..
					echo -n $w, >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					tail -1 $w/pdbbind-$v-trn-$trn-trn-$trn-stat.csv >> pdbbind-$v-trn-$trn-trn-$trn-stat.csv
					for tst in $tsts; do
						echo -n $w, >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
						tail -1 $w/pdbbind-$v-trn-$trn-tst-$tst-stat.csv >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					done
				done
				for tst in $tsts; do
					b=$(tail -n +2 pdbbind-$v-trn-$trn-tst-$tst-stat.csv | sort -t, -k3,3n -k4,4n -k5,5nr -k6,6nr -k7,7nr | head -1)
					echo $v,$trn,$tst,$b >> tst-stat-0.csv
					echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					echo $b >> pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
			done
		done
		echo v,trn,tst,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
		sort -t, -k1,1n tst-stat-0.csv >> tst-stat.csv
		rm tst-stat-0.csv
		cd ..
	done
	cd ..
done
