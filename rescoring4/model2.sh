for m in 2; do
	echo model$m
	cd model$m
	for s in 2; do
		echo set$s
		cd set$s
		v=2012
		echo trn,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
		for trn in $(ls -1 pdbbind-$v-trn-*-yxi.csv | cut -d- -f4); do
			echo trn$trn
			echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-stat.csv
			for w in $(seq 0.005 0.001 0.020); do
				echo $w
				mkdir -p $w
				cd $w
				../../../model2train.R $v $trn $w
				../../../model2test.R $v $trn $w tst
				../../../iypplot.R $v $trn tst
				cd ..
				echo -n $w, >> pdbbind-$v-trn-$trn-tst-stat.csv
				tail -1 $w/pdbbind-$v-trn-$trn-tst-stat.csv >> pdbbind-$v-trn-$trn-tst-stat.csv
			done
			b=$(tail -n +2 pdbbind-$v-trn-$trn-tst-stat.csv | sort -t, -k3,3n -k4,4n -k5,5nr -k6,6nr -k7,7nr | head -1)
			echo $trn,$b >> tst-stat.csv
			echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-stat.csv
			echo $b >> pdbbind-$v-trn-$trn-tst-stat.csv
		done
		cd ..
	done
	cd ..
done
