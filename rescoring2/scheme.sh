pdbbind=~/PDBbind
declare -A v
v[1,0]=2007
v[1,1]=2004
v[1,2]=2007
v[1,3]=2010
v[1,4]=2013
v[2,0]=2013
v[2,1]=2002
v[2,2]=2007
v[2,3]=2010
v[2,4]=2012
for s in 1 2; do
	echo set$s
	for vi in {1..4}; do
		cd $pdbbind/v${v[$s,$vi]}
		for trn in 0; do
			if [[ $vi == 0 ]]; then
				echo tst-$trn-yxi.csv
				for c in $(cut -d, -f1 rescoring-2-set-$s-tst-iy.csv)
				do
					cd $c
					n=$(wc -l < vina.rmsd)
					seq 1 $n | paste - vina.rmsd | sort -k2nr | head -1 | cut -f1 > vina-scheme-$trn.txt
					cd ..
				done
			else
				echo pdbbind-${v[$s,$vi]}-trn-$trn-yxi.csv
				for c in $(cut -d, -f1 rescoring-2-set-$s-trn-iy.csv)
				do
					cd $c
					n=$(wc -l < vina.rmsd)
					seq 1 $n | paste - vina.rmsd | sort -k2nr | head -1 | cut -f1 > vina-scheme-$trn.txt
					cd ..
				done
			fi
		done
	done
done
