#!/bin/bash
JEMALLOCN=$HOME/Scout/jemallocn/lib
JEMALLOC2k=$HOME/Scout/jemalloc2k/lib
SPECDIR=$HOME/Scout/SPEC

export LD_LIBRARY_PATH=$JEMALLOCN:$JEMALLOC2k:$LD_LIBRARY_PATH

source shrc
SIZE="ref"
ITER=1
BENCHMARK="519.lbm_r 505.mcf_r 544.nab_r 538.imagick_r 557.xz_r 525.x264_r 500.perlbench_r 502.gcc_r 520.omnetpp_r 523.xalancbmk_r 531.deepsjeng_r 541.leela_r 508.namd_r 510.parest_r 511.povray_r 526.blender_r"

for val in $BENCHMARK
do
	cd $SPECDIR/result && rm -r *
	export FILENAME=$val
	rm -r $HOME/stats/"$FILENAME"_ModuleInfo.txt
	rm -r $HOME/stats/"$FILENAME"_FunctionInfo.txt
	rm -r $HOME/stats/"$FILENAME"_LoopTimeStats.txt

	runcpu --config=Native_profiler --noreportable --tune=base --copies=1 --iteration=1 --action=clobber --size=$SIZE $val >> output.txt
	runcpu --config=Native_profiler --noreportable --tune=base --copies=1 --iteration=$ITER --size=$SIZE $val >> output.txt
	cp $HOME/stats/"$FILENAME"_LoopTimeStats.txt $HOME/stats/native/
	rm -r $HOME/stats/"$FILENAME"_LoopTimeStats.txt

	runcpu --config=Scout_profiler --noreportable --tune=base --copies=1 --iteration=1 --action=clobber --size=$SIZE $val >> output.txt
	runcpu --config=Scout_profiler --noreportable --tune=base --copies=1 --iteration=$ITER --size=$SIZE $val >> output.txt
	cp $HOME/stats/"$FILENAME"_LoopTimeStats.txt $HOME/stats/runtime/
done
