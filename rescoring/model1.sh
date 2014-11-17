for m in 1; do
	echo model$m
	cd model$m
	for s in 1 2 3; do
		echo set$s
		cd set$s
		for t in trn tst; do
			../../iypplot.R 2007 $t
		done
		cd ..
	done
	cd ..
done
