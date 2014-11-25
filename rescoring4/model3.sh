for m in 3 4; do
	echo model$m
	cd model$m
	for s in 2; do
		echo set$s
		cd set$s
		v=2012
		echo trn,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
		for trn in $(ls -1 pdbbind-$v-trn-*-yxi.csv | cut -d- -f4); do
			echo trn$trn
			echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-$trn-tst-stat.csv
			for w in 89757 35577 51105 72551 10642 69834 47945 52857 26894 99789; do
				echo $w
				mkdir -p $w
				cd $w
				rf-train ../pdbbind-$v-trn-$trn-yxi.csv pdbbind-$v-trn-$trn.rf $w > pdbbind-$v-trn-$trn.txt
				rf-test pdbbind-$v-trn-$trn.rf ../tst-yxi.csv > pdbbind-$v-trn-$trn-tst-iyp.csv
				../../../iypplot.R $v $trn tst
#				tail -n +6 pdbbind-$v-trn-$trn.txt | awk '{print substr($0,4,8)}' | ../../../varImpPlot.R $v $trn
				cd ..
				echo -n $w, >> pdbbind-$v-trn-$trn-tst-stat.csv
				tail -1 $w/pdbbind-$v-trn-$trn-tst-stat.csv >> pdbbind-$v-trn-$trn-tst-stat.csv
			done
			echo -n $trn, >> tst-stat.csv
			tail -n +2 pdbbind-$v-trn-$trn-tst-stat.csv | sort -t, -k3,3n -k4,4n -k5,5nr -k6,6nr -k7,7nr | head -1 >> tst-stat.csv
		done
		cd ..
	done
	cd ..
done
