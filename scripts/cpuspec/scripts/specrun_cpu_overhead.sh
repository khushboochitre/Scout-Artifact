#!/bin/bash
JEMALLOCN=$HOME/Scout/jemallocn/lib
JEMALLOC2k=$HOME/Scout/jemalloc2k/lib
SPECDIR=$HOME/Scout/SPEC

export LD_LIBRARY_PATH=$JEMALLOCN:$JEMALLOC2k:$LD_LIBRARY_PATH

source shrc
SIZE="ref"
ITER=5
BENCHMARK="519.lbm_r 505.mcf_r 544.nab_r 538.imagick_r 557.xz_r 525.x264_r 500.perlbench_r 502.gcc_r 520.omnetpp_r 523.xalancbmk_r 531.deepsjeng_r 541.leela_r 508.namd_r 510.parest_r 511.povray_r 526.blender_r"

if [ $SIZE == "ref" ];
then
	EXT="refrate"
elif [ $SIZE == "test" ];
then
	EXT="test"
fi

cd $SPECDIR/result && rm -r *
runcpu --config=Native_jemalloc --noreportable --tune=base --copies=1 --iteration=1 --action=clobber --size=$SIZE $BENCHMARK >> output.txt
runcpu --config=Native_jemalloc --noreportable --tune=base --copies=1 --iteration=$ITER --size=$SIZE $BENCHMARK >> output.txt

runcpu --config=Native_jemalloc2k --noreportable --tune=base --copies=1 --iteration=1 --action=clobber --size=$SIZE $BENCHMARK >> output.txt
runcpu --config=Native_jemalloc2k --noreportable --tune=base --copies=1 --iteration=$ITER --size=$SIZE $BENCHMARK >> output.txt

file1="$SPECDIR/result/CPU2017.002.fprate."$EXT".txt"
file2="$SPECDIR/result/CPU2017.004.fprate."$EXT".txt"
file3="$SPECDIR/result/CPU2017.002.intrate."$EXT".txt"
file4="$SPECDIR/result/CPU2017.004.intrate."$EXT".txt"

function compute_improvement() {
	file1=$1 
	file2=$2
	COUNT=$3

	declare -A SUM1
	declare -A AVG1
	read_line=0
	while IFS= read -r line;
	do
		if [[ "$line" == *"--------------- -------  ---------  ---------    -------  ---------  ---------"* ]];
		then
			read_line=1
	    elif [[ "$line" == *"================================================================================="* ]]; 
	    then
	        read_line=0
	    elif [[ $read_line == 1 ]]; 
	    then
	        words=`echo $line | sed 's/^ *//g'`
	        word_count=0
	        benchname=""
	        timeval=0
	        for word in $words
	        do
	            if [ $word_count == 0 ];
	            then
	                benchname=$word
	                if [ ${SUM1[$benchname]} ];
	               	then
	                    SUM1[$benchname]=${SUM1[$benchname]}
	                else
	                    SUM1[$benchname]=0
	                fi
	                elif [ $word_count == 2 ];
	                then
	                    timeval=$word
	                if [ ${SUM1[$benchname]} ];
	                then
	                    val=`echo "${SUM1[$benchname]}+$timeval" | bc`
	                    SUM1[$benchname]=$val
	                fi
	            fi
	            ((word_count=word_count+1))
	        done
	    fi
	done < $file1

	#echo "Avg1"
	for x in "${!SUM1[@]}"; do
		res=`echo ${SUM1[$x]} '>' 0 | bc -l`
	    if [ $res == 1 ]; then
	        val=`bc <<<"scale=2; ${SUM1[$x]}/$COUNT"`
	        #printf "%s %s \n" "$x" "$val" ;
	        AVG1[$x]=$val
	    fi
	done

	declare -A SUM2
	declare -A AVG2
	read_line=0
	while IFS= read -r line;
	do
		if [[ "$line" == *"--------------- -------  ---------  ---------    -------  ---------  ---------"* ]];
		then
			read_line=1
	    elif [[ "$line" == *"================================================================================="* ]]; 
	    then
	        read_line=0
	    elif [[ $read_line == 1 ]]; 
	    then
	        words=`echo $line | sed 's/^ *//g'`
	        word_count=0
	        benchname=""
	        timeval=0
	        for word in $words
	        do
	            if [ $word_count == 0 ];
	            then
	                benchname=$word
	                if [ ${SUM2[$benchname]} ];
	               	then
	                    SUM2[$benchname]=${SUM2[$benchname]}
	                else
	                    SUM2[$benchname]=0
	                fi
	                elif [ $word_count == 2 ];
	                then
	                    timeval=$word
	                if [ ${SUM2[$benchname]} ];
	                then
	                    val=`echo "${SUM2[$benchname]}+$timeval" | bc`
	                    SUM2[$benchname]=$val
	                fi
	            fi
	            ((word_count=word_count+1))
	        done
	    fi
	done < $file2

	#echo "Avg2"
	for x in "${!SUM2[@]}"; do
	    res=`echo ${SUM2[$x]} '>' 0 | bc -l`
	    if [ $res == 1 ]; then
	        val=`bc <<<"scale=2; ${SUM2[$x]}/$COUNT"`
	        #printf "%s %s \n" "$x" "$val" ;
	        AVG2[$x]=$val
	        improvement=`bc <<<"scale=2; (((${AVG2[$x]}-${AVG1[$x]})*100) / ${AVG1[$x]})"`
        	printf "%s %s \n" "$x" "$improvement" ;
	    fi
	done
}

echo "CPU Overhead"
compute_improvement $file1 $file2 $ITER
compute_improvement $file3 $file4 $ITER
