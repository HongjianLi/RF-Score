for m in 2; do
	echo model$m
	cd model$m
	for s in 3; do
		echo set$s
		cd set$s
		for trn in 0; do
			echo trn$trn
			tsts=$(seq 0 5)
			for v in $(ls -1 pdbbind-*-trn-0-yxi.csv | cut -d- -f2); do
				echo $v
				for tst in $tsts; do
					echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
				done
				for w in $(seq 0.005 0.001 0.020); do
					echo $w
					mkdir -p $w
					cd $w
					../../../mlrtrain.R $v $trn $w
					for tst in $tsts; do
						../../../mlrtest.R $v $trn $tst $w
						cut -d, -f2 ../../../set3/tst-$tst-iy.csv | paste -d, - pdbbind-$v-trn-$trn-tst-$tst-p.csv | rf-stat > pdbbind-$v-trn-$trn-tst-$tst-stat.csv
					done
					cd ..
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
