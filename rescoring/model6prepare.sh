for m in 6; do
	echo model$m
	cd model$m
	for s in 1 2; do
		echo set$s
		cd set$s
		cut -d, -f1-42 ../../model4/set$s/tst-yxi.csv > tst-yx.csv
		cut -d, -f7- ../../model2/set$s/tst-yxi.csv | paste -d, tst-yx.csv - > tst-yxi.csv
		rm tst-yx.csv
		for v in $([[ $s == 1 ]] && echo "2007" || echo "2002 2007 2010 2012"); do
			cut -d, -f1-42 ../../model4/set$s/pdbbind-$v-trn-yxi.csv > pdbbind-$v-trn-yx.csv
			cut -d, -f7- ../../model2/set$s/pdbbind-$v-trn-yxi.csv | paste -d, pdbbind-$v-trn-yx.csv - > pdbbind-$v-trn-yxi.csv
			rm pdbbind-$v-trn-yx.csv
		done
		cd ..
	done
	cd ..
done
