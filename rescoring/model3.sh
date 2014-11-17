for m in 3 4 5; do
	echo model$m
	cd model$m
	for s in 1 2 3; do
		echo set$s
		cd set$s
		echo v,w,n,rmse,sdev,pcor,scor,kcor > tst-stat.csv
		for v in $(ls -1 pdbbind-*-trn-yxi.csv | cut -d- -f2); do
			echo $v
			echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-tst-stat.csv
			echo seed,n,rmse,sdev,pcor,scor,kcor > pdbbind-$v-trn-stat.csv
			for w in 89757 35577 51105 72551 10642 69834 47945 52857 26894 99789; do
				echo $w
				mkdir -p $w
				cd $w
				rf-train ../pdbbind-$v-trn-yxi.csv pdbbind-$v.rf $w > pdbbind-$v.txt
				rf-test pdbbind-$v.rf ../pdbbind-$v-trn-yxi.csv > pdbbind-$v-trn-iyp.csv
				rf-test pdbbind-$v.rf ../tst-yxi.csv > pdbbind-$v-tst-iyp.csv
				../../../iypplot.R $v trn
				../../../iypplot.R $v tst
#				tail -n +6 pdbbind-$v.txt | awk '{print substr($0,4,8)}' | ../../../varImpPlot.R $v
				cd ..
				echo -n $w, >> pdbbind-$v-tst-stat.csv
				echo -n $w, >> pdbbind-$v-trn-stat.csv
				tail -1 $w/pdbbind-$v-tst-stat.csv >> pdbbind-$v-tst-stat.csv
				tail -1 $w/pdbbind-$v-trn-stat.csv >> pdbbind-$v-trn-stat.csv
			done
			echo -n $v, >> tst-stat.csv
			tail -n +2 pdbbind-$v-tst-stat.csv | sort -t, -k3,3n -k4,4n -k5,5nr -k6,6nr -k7,7nr | head -1 >> tst-stat.csv
		done
		cd ..
	done
	cd ..
done
