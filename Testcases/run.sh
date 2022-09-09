JEMALLOCN=$HOME/Scout/jemallocn/lib
JEMALLOC2k=$HOME/Scout/jemalloc2k/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JEMALLOC2k:$JEMALLOCN

LLVM_ROOT_PATH=$HOME/Scout/build
LLVM_LIB_PATH=$HOME/Scout/build/lib
CLANG=$LLVM_ROOT_PATH/bin/clang
INPUT="test.c"
EXEOUTPUT="test"
VAL=0  #THRESHOLD.
NATIVE_JEMALLOC_FLAGS="-mllvm -disable-additional-vectorize -O3 -g"
NATIVE_JEMALLOC2k_FLAGS="-O3 -mllvm -disable-additional-vectorize -g -allocator2k"
SCOUT_FLAGS="-O3 -g -allocator2k -mllvm -stats"
NATIVE_JEMALLOC2k_PROF="-O3 $LLVM_LIB_PATH/Transforms/Vectorize/CMakeFiles/LLVMVectorize.dir/InstrumentFunction.cpp.o -g -allocator2k -mllvm -get-time-stats -mllvm $EXEOUTPUT -mllvm -execute-unoptimized-path"
SCOUT_JEMALLOC2k_PROF="-O3 -mllvm -stats $LLVM_LIB_PATH/Transforms/Vectorize/CMakeFiles/LLVMVectorize.dir/InstrumentFunction.cpp.o -g -allocator2k -mllvm -get-time-stats -mllvm $EXEOUTPUT"
SCOUT_PROF_IMPROV="-O3 -mllvm -stats $LLVM_LIB_PATH/Transforms/Vectorize/CMakeFiles/LLVMVectorize.dir/InstrumentFunction.cpp.o -g -allocator2k -mllvm -allow-ben-loops -mllvm $EXEOUTPUT -mllvm -ben-loop-threshold -mllvm $VAL"

NATIVE_LIB_FLAGS="-L$JEMALLOCN -ljemalloc2"
JEMALLOC2k_LIB_FLAGS="-L$JEMALLOC2k -ljemalloc1 -lsupport"

echo "Jemallocn execution time and memory consumption"
$CLANG $NATIVE_JEMALLOC_FLAGS $INPUT -o $EXEOUTPUT $NATIVE_LIB_FLAGS
time ./$EXEOUTPUT > out.txt 2>&1
time /usr/bin/time -f "%M" 2>&1 ./$EXEOUTPUT 1>/dev/null

echo "Jemalloc2k native execution time and memory consumption"
$CLANG $NATIVE_JEMALLOC2k_FLAGS $INPUT -o $EXEOUTPUT $JEMALLOC2k_LIB_FLAGS
time ./$EXEOUTPUT > out.txt 2>&1
time /usr/bin/time -f "%M" 2>&1 ./$EXEOUTPUT 1>/dev/null

echo "Jemalloc2k scout execution time"
$CLANG $SCOUT_FLAGS $INPUT -o $EXEOUTPUT $JEMALLOC2k_LIB_FLAGS
time ./$EXEOUTPUT > out.txt 2>&1

rm -r $HOME/stats/$EXEOUTPUT*
echo "Native profiler execution time"
$CLANG $NATIVE_JEMALLOC2k_PROF $INPUT -o $EXEOUTPUT $JEMALLOC2k_LIB_FLAGS
time ./$EXEOUTPUT > out.txt 2>&1
cp $HOME/stats/"$EXEOUTPUT"_LoopTimeStats.txt $HOME/stats/native/

rm -r $HOME/stats/"$EXEOUTPUT"_LoopTimeStats.txt
echo "Scout profiler execution time"
$CLANG $SCOUT_JEMALLOC2k_PROF $INPUT -o $EXEOUTPUT $JEMALLOC2k_LIB_FLAGS
time ./$EXEOUTPUT > out.txt 2>&1
cp $HOME/stats/"$EXEOUTPUT"_LoopTimeStats.txt $HOME/stats/runtime/

echo "Scout execution time for threshold $VAL"
$CLANG $SCOUT_PROF_IMPROV $INPUT -o $EXEOUTPUT $JEMALLOC2k_LIB_FLAGS
time ./$EXEOUTPUT > out.txt 2>&1
