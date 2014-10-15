echo "model,trial,partition,w,n,rmse,sdev,pcor,scor,kcor"
for m in 2 3 4; do
	yes $m | head -n 51 | paste -d, - model$m/set2/pdbbind-2012-tst-t-p-stat.csv | tail -n +2
done
