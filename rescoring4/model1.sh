for m in 1; do
	echo model$m
	cd model$m
	for s in 2; do
		echo set$s
		cd set$s
		ln -s ../../../rescoring/model1/set2/pdbbind-2007-tst-stat.csv pdbbind-2007-trn-0-tst-stat.csv
		cd ..
	done
	cd ..
done
