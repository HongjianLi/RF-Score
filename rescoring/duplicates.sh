pdbbind=~/PDBbind
nva=(0 4 5 2)
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
v[2,5]=2014
v[3,0]=2013
v[3,1]=2013
v[3,2]=2014
t=(tst trn trn trn trn trn)
for s in 1 2 3; do
	echo set$s
	nv=${nva[$s]}
	for v0 in $(seq 0 $((nv-1))); do
	for v1 in $(seq $((v0+1)) $nv); do
		echo "|$v0 ∩ $v1| = "$(cut -d, -f1 $pdbbind/v${v[$s,$v0]}/rescoring-1-set-$s-${t[v0]}-iy.csv $pdbbind/v${v[$s,$v1]}/rescoring-1-set-$s-${t[v1]}-iy.csv | sort | uniq -d | wc -l)
	done
	done
done
