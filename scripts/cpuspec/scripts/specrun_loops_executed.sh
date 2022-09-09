#!/bin/bash
JEMALLOCN=$HOME/Scout/jemallocn/lib
JEMALLOC2k=$HOME/Scout/jemalloc2k/lib
SPECDIR=$HOME/Scout/SPEC

export LD_LIBRARY_PATH=$JEMALLOCN:$JEMALLOC2k:$LD_LIBRARY_PATH

source shrc
SIZE="ref"
ITER=1
BENCHMARK="519.lbm_r 505.mcf_r 544.nab_r 538.imagick_r 557.xz_r 525.x264_r 500.perlbench_r 502.gcc_r 520.omnetpp_r 523.xalancbmk_r 531.deepsjeng_r 541.leela_r 508.namd_r 510.parest_r 511.povray_r 526.blender_r"

cd $SPECDIR/result && rm -r *
echo "Total number of versioned loops executed"
for val in $BENCHMARK
do
	rm -r $HOME/stats/"$val"_LoopTakenStats.txt
	export FILENAME=$val
	runcpu --config=Scout_loop_executed --noreportable --tune=base --copies=1 --iteration=1 --action=clobber --size=$SIZE $val >> output.txt
	runcpu --config=Scout_loop_executed --noreportable --tune=base --copies=1 --iteration=$ITER --size=$SIZE $val >> output.txt

	PATH="$HOME/stats/"$val"_LoopTakenStats.txt"
	count=0
	for input in $PATH
	do
		while IFS= read -r line;
		do
			read -a arr <<< $line
			if [ "${arr[2]}" -gt 0 ] ;
			then
				((count=count+1))
			fi
		done < "$input"
	done

	echo "$val  $count"
done

