#!/bin/bash
JEMALLOCN=$HOME/Scout/jemallocn/lib
JEMALLOC2k=$HOME/Scout/jemalloc2k/lib

export LD_LIBRARY_PATH=$JEMALLOCN:$JEMALLOC2k:$LD_LIBRARY_PATH

POLYBENCH=$HOME/Scout/polybench-c-4.2.1-beta
LLVM_ROOT_PATH=$HOME/Scout/build
CLANG=$LLVM_ROOT_PATH/bin/clang
EXE_FILES=$POLYBENCH/exe
NATIVE_JEMALLOC_FLAGS="-mllvm -disable-additional-vectorize -O3 -g"
NATIVE_JEMALLOC2k_FLAGS="-O3 -mllvm -disable-additional-vectorize -g -allocator2k"

NATIVE_LIB_FLAGS="-L$JEMALLOCN -ljemalloc2"
JEMALLOC2k_LIB_FLAGS="-L$JEMALLOC2k -ljemalloc1 -lsupport"

iter=5
BENCHMARK="gemm symm doitgen jacobi-2d"
#BENCHMARK="correlation covariance gemm gemver gesummv symm syr2k syrk trmm 2mm 3mm atax bicg doitgen mvt cholesky durbin gramschmidt lu ludcmp trisolv deriche floyd-warshall nussinov adi fdtd-2d heat-3d jacobi-1d jacobi-2d seidel-2d"

for val in $BENCHMARK
do
    if [ $val == "correlation" ] || [ $val == "covariance" ];
    then
        echo $val
        $CLANG $NATIVE_JEMALLOC_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/datamining/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/datamining/$val/$val.c -o $EXE_FILES/$val $NATIVE_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem1=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
            
        $CLANG $NATIVE_JEMALLOC2k_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/datamining/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/datamining/$val/$val.c -o $EXE_FILES/$val $JEMALLOC2k_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem2=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
        overhead=`bc <<<"scale=2; ((($mem2-$mem1)*100) / $mem1)"`
        echo $overhead
    elif [ $val == "gemm" ] || [ $val == "gemver" ] || [ $val == "gesummv" ] || [ $val == "symm" ] || [ $val == "syr2k" ] || [ $val == "syrk" ] || [ $val == "trmm" ];
    then
        echo $val
        $CLANG $NATIVE_JEMALLOC_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/linear-algebra/blas/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/linear-algebra/blas/$val/$val.c -o $EXE_FILES/$val $NATIVE_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem1=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
            
        $CLANG $NATIVE_JEMALLOC2k_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/linear-algebra/blas/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/linear-algebra/blas/$val/$val.c -o $EXE_FILES/$val $JEMALLOC2k_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem2=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
        overhead=`bc <<<"scale=2; ((($mem2-$mem1)*100) / $mem1)"`
        echo $overhead
    elif [ $val == "2mm" ] || [ $val == "3mm" ] || [ $val == "atax" ] || [ $val == "bicg" ] || [ $val == "doitgen" ] || [ $val == "mvt" ];
    then
        echo $val
        $CLANG $NATIVE_JEMALLOC_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/linear-algebra/kernels/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/linear-algebra/kernels/$val/$val.c -o $EXE_FILES/$val $NATIVE_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem1=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
            
        $CLANG $NATIVE_JEMALLOC2k_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/linear-algebra/kernels/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/linear-algebra/kernels/$val/$val.c -o $EXE_FILES/$val $JEMALLOC2k_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem2=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
        overhead=`bc <<<"scale=2; ((($mem2-$mem1)*100) / $mem1)"`
        echo $overhead
    elif [ $val == "cholesky" ] || [ $val == "durbin" ] || [ $val == "gramschmidt" ] || [ $val == "lu" ] || [ $val == "ludcmp" ] || [ $val == "trisolv" ];
    then
        echo $val
        $CLANG $NATIVE_JEMALLOC_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/linear-algebra/solvers/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/linear-algebra/solvers/$val/$val.c -o $EXE_FILES/$val $NATIVE_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem1=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
            
        $CLANG $NATIVE_JEMALLOC2k_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/linear-algebra/solvers/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/linear-algebra/solvers/$val/$val.c -o $EXE_FILES/$val $JEMALLOC2k_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem2=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
        overhead=`bc <<<"scale=2; ((($mem2-$mem1)*100) / $mem1)"`
        echo $overhead
    elif [ $val == "deriche" ] || [ $val == "floyd-warshall" ] || [ $val == "nussinov" ];
    then
        echo $val
        $CLANG $NATIVE_JEMALLOC_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/medley/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/medley/$val/$val.c -o $EXE_FILES/$val $NATIVE_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem1=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
            
        $CLANG $NATIVE_JEMALLOC2k_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/medley/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/medley/$val/$val.c -o $EXE_FILES/$val $JEMALLOC2k_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem2=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
        overhead=`bc <<<"scale=2; ((($mem2-$mem1)*100) / $mem1)"`
        echo $overhead
    elif [ $val == "adi" ] || [ $val == "fdtd-2d" ] || [ $val == "heat-3d" ] || [ $val == "jacobi-1d" ] || [ $val == "jacobi-2d" ] || [ $val == "seidel-2d" ];
    then
        echo $val
        $CLANG $NATIVE_JEMALLOC_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/stencils/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/stencils/$val/$val.c -o $EXE_FILES/$val $NATIVE_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem1=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)

        $CLANG $NATIVE_JEMALLOC2k_FLAGS -I $POLYBENCH/utilities -I $POLYBENCH/stencils/$val $POLYBENCH/utilities/polybench.c $POLYBENCH/stencils/$val/$val.c -o $EXE_FILES/$val $JEMALLOC2k_LIB_FLAGS -lm
        cd $EXE_FILES/ && mem2=$(/usr/bin/time -f "%M" 2>&1 ./$val 1>/dev/null)
        overhead=`bc <<<"scale=2; ((($mem2-$mem1)*100) / $mem1)"`
        echo $overhead
    else
            echo "Please enter valid benchmark name."
    fi
done
