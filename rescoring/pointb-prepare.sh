for t in $(seq 0 9); do
	shuf -i 1-382 > pointb-$t.csv
done
n=(77 77 76 76 76)
for m in 2 3 4; do
	echo model$m
	cd model$m
	for s in 2; do
		echo set$s
		cd set$s
		for t in $(seq 0 9); do
			h=1
			for p in $(seq 0 4); do
				head -1 tst-yxi.csv > tst-$t-$p-yxi.csv
				for r in $(tail -n +$h ../../pointb-$t.csv | head -${n[$p]}); do
					tail -n +$((1+$r)) tst-yxi.csv | head -1 >> tst-$t-$p-yxi.csv
				done
				h=$(($h+${n[$p]}))
			done
		done
		cd ..
	done
	cd ..
done
