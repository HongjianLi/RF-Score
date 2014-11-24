for m in 2; do
	echo model$m
	cd model$m
	for s in 2; do
		echo set$s
		cd set$s
		for v in 2012; do
			echo $v
			echo t,p,w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-t-p-stat.csv
			for t in $(seq 0 9); do
				echo trial$t
				for p in $(seq 0 4); do
					echo partition$p
					echo w,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-$t-$p-stat.csv
					for w in $(seq 0.005 0.001 0.020); do
						echo $w
						cd $w
						../../../model2test.R $v $w tst-$t-$p
						../../../iypplot.R $v tst-$t-$p
						cd ..
						echo -n $w, >> pdbbind-$v-tst-$t-$p-stat.csv
						tail -1 $w/pdbbind-$v-tst-$t-$p-stat.csv >> pdbbind-$v-tst-$t-$p-stat.csv
					done
					echo -n $t,$p, >> pdbbind-$v-tst-t-p-stat.csv
					tail -n +2 pdbbind-$v-tst-$t-$p-stat.csv | sort -t, -k3,3n -k4,4n -k5,5nr -k6,6nr -k7,7nr | head -1 >> pdbbind-$v-tst-t-p-stat.csv
				done
			done
		done
		cd ..
	done
	cd ..
done
