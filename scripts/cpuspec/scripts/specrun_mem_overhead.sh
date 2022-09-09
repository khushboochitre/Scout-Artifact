#!/bin/bash
JEMALLOCN=$HOME/Scout/jemallocn/lib
JEMALLOC2k=$HOME/Scout/jemalloc2k/lib
SPECDIR=$HOME/Scout/SPEC

export LD_LIBRARY_PATH=$JEMALLOCN:$JEMALLOC2k:$LD_LIBRARY_PATH

source shrc
SIZE="ref"
ITER=1
BENCHMARK="519.lbm_r 505.mcf_r 544.nab_r 538.imagick_r 557.xz_r 525.x264_r 500.perlbench_r 502.gcc_r 520.omnetpp_r 523.xalancbmk_r 531.deepsjeng_r 541.leela_r 508.namd_r 510.parest_r 511.povray_r 526.blender_r"

echo "Memory overhead"
cd $SPECDIR/result && rm -r *
for val in $BENCHMARK
do
	export FILENAME=$val
	rm -r $HOME/stats/"$FILENAME"_mem_overhead_jemalloc.txt
	runcpu --config=Native_jemalloc_mem --noreportable --tune=base --copies=1 --iteration=1 --action=clobber --size=$SIZE $val >> output.txt
	runcpu --config=Native_jemalloc_mem --noreportable --tune=base --copies=1 --iteration=$ITER --size=$SIZE $val >> output.txt
	
	rm -r $HOME/stats/"$FILENAME"_mem_overhead_jemalloc2k.txt
	runcpu --config=Native_jemalloc2k_mem --noreportable --tune=base --copies=1 --iteration=1 --action=clobber --size=$SIZE $val >> output.txt
	runcpu --config=Native_jemalloc2k_mem --noreportable --tune=base --copies=1 --iteration=$ITER --size=$SIZE $val >> output.txt

	file1="$HOME"/stats/"$FILENAME"_mem_overhead_jemalloc.txt
	file2="$HOME"/stats/"$FILENAME"_mem_overhead_jemalloc2k.txt
	mem1=0	
	for input in $file1
	do
		while IFS= read -r line;
		do
			read -a arr <<< $line
			if [ "${arr[0]}" -gt $mem1 ];
			then
				mem1=${arr[0]}
			fi
		done < "$input"
	done

	mem2=0	
	for input in $file2
	do
		while IFS= read -r line;
		do
			read -a arr <<< $line
			if [ "${arr[0]}" -gt $mem2 ];
			then
				mem2=${arr[0]}
			fi
		done < "$input"
	done

	overhead=`bc <<<"scale=2; ((($mem2-$mem1)*100) / $mem1)"`
    echo $val $overhead
done
