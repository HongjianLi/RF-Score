for m in 0; do
	echo model$m
	cd model$m
	for s in 1 2 3; do
		echo set$s
		cd set$s
		for v in $(ls -1 pdbbind-*-trn-yxi.csv | cut -d- -f2); do
			echo $v
			for w in 2 3; do
				echo $w
				mkdir -p $w
				cd $w
				../../../model0train.R $v $w
				../../../model0test.R $v $w tst
				../../../iypplot.R $v tst
				cd ..
			done
		done
		cd ..
	done
	cd ..
done
