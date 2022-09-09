Installing the dependencies
=====================================

sudo apt-get install build-essential

sudo apt-get install cmake

sudo apt-get install autoconf

sudo apt-get install -y libffi-dev

sudo apt install ninja-build


Setting up Scout
=====================================

1) Download the zip file using the following link:


2) Extract the zip file to the $HOME folder.
unzip path/to/zip -d $HOME/
cd $HOME/Scout/

3) Create two new folders.
mkdir build
mkdir build_3.6.0

4) Building Scout.
cp $HOME/Scout/scripts/other/build.sh $HOME/Scout/build/
cd $HOME/Scout/build/
chmod +x build.sh
./build.sh
ninja

5) Building LLVM-3.6.0.
cp $HOME/Scout/scripts/other/build_3.6.0.sh $HOME/Scout/build_3.6.0/
cd $HOME/Scout/build_3.6.0/
chmod +x build_3.6.0.sh
./build_3.6.0.sh
ninja

6) Building jemallocn.
cd $HOME/Scout/jemallocn/
./autogen.sh
make

7) Building jemalloc2k.
cd $HOME/Scout/jemalloc2k/
./autogen.sh
make

8) Create folders to generate the profile files.
mkdir $HOME/stats
mkdir $HOME/stats/native
mkdir $HOME/stats/runtime


Running example test.c
=====================================
cd $HOME/Scout/Testcases/
chmod +x run.sh
./run.sh

The output of this script is divided into the following parts:

1) Execution time and memory consumption of the program when compiled with the native JEMALLOC allocator and the following options:
FLAGS="-mllvm -disable-additional-vectorize -O3 -g"
LIB="path/to/jemallocn -ljemalloc2"

2) Execution time and memory consumption of the program when compiled with the custom allocator and the following options:
FLAGS="-O3 -mllvm -disable-additional-vectorize -g -allocator2k"
LIB="path/to/jemalloc2k -ljemalloc1 -lsupport"

3) Execution time and statistics of the program when compiled with Scout using the following options:
FLAGS="-O3 -g -allocator2k -mllvm -stats"
LIB="path/to/jemalloc2k -ljemalloc1 -lsupport"

4) Generate the profile file when compiled with the custom allocator using the following options:
FLAGS="-O3 $LLVM_LIB_PATH/Transforms/Vectorize/CMakeFiles/LLVMVectorize.dir/InstrumentFunction.cpp.o -g -allocator2k -mllvm -get-time-stats -mllvm test -mllvm -execute-unoptimized-path"
LIB="path/to/jemalloc2k -ljemalloc1 -lsupport"
The profile file will be generated in the folder $HOME/stats/native/

5) Generate the profile file when compiled with Scout using the following options:
FLAGS="-O3 -mllvm -stats $LLVM_LIB_PATH/Transforms/Vectorize/CMakeFiles/LLVMVectorize.dir/InstrumentFunction.cpp.o -g -allocator2k -mllvm -get-time-stats -mllvm test"
LIB="path/to/jemalloc2k -ljemalloc1 -lsupport"
The profile file will be generated in the folder $HOME/stats/runtime/

6) Execution time taken by the program when selected loops are versioned based on the profiler's feedback using the following options:
VAL=0
FLAGS="-O3 -mllvm -stats $LLVM_LIB_PATH/Transforms/Vectorize/CMakeFiles/LLVMVectorize.dir/InstrumentFunction.cpp.o -g -allocator2k -mllvm -allow-ben-loops -mllvm test -mllvm -ben-loop-threshold -mllvm $VAL"
LIB="path/to/jemalloc2k -ljemalloc1 -lsupport"
The value of the variable VAL can be modified to change the threshold (default = 0).


Running Polybench benchmarks
=====================================
cd $HOME/Scout/polybench-c-4.2.1-beta/
mkdir exe
cd $HOME/Scout/scripts/polybench/
chmod +x *.sh


To reproduce Table 2 in paper, run the following command,
./table2.sh

Description of the output: The output of this script is divided into four parts. The first part presents the CPU overhead of the custom allocator w.r.t. The native JEMALLOC allocator when compiled using the default size of memory allocations, CD. The second part presents the CPU overhead of the custom allocator w.r.t. the native JEMALLOC allocator when the size of the memory allocations is aligned to 2^K, CA. The third part presents the memory overhead of the custom allocator w.r.t. the native JEMALLOC allocator when compiled using the default size of memory allocations, MD. The fourth part presents the memory overhead of the custom allocator w.r.t. the native JEMALLOC allocator when the size of the memory allocations is aligned to 2^K, MA.


To reproduce Table 3 in paper, run the following command,
./table3.sh

Description of the output: The output of this script is divided into three parts. The first part presents the total number of loops versioned by Scout for the six benchmarks, #La. The second part presents the performance benefits when the benchmarks are compiled using Scout, Pa. The third part presents the performance benefits when the benchmarks are compiled with the restrict keyword, Pr.


To reproduce Table 4 in paper, run the following command,
./table4.sh

Description of the output: The output of this script is divided into three parts. The first part presents the speedups when the benchmarks are compiled with the restrict keyword using LLVM-3.6.0, Sra. The second part presents the speedups when the benchmarks are compiled using Scout, Ss. The third part presents the speedups when the benchmarks are compiled with the restrict keyword using LLVM-10, Srb.


Setting up CPU SPEC 2017
=====================================
Assuming the ISO image for CPU SPEC 2017 benchmarks is available,
1) Create the CPU SPEC 2017 installation directory.
cd $HOME/Scout/
mkdir cpuspec

2) Mount the ISO image by right-clicking on the .iso file and selecting "Open with Disk Image Mounter".

3) Open a terminal in the mounted file system and type,
./install.sh -d cd $HOME/Scout/cpuspec/

4) Confirm the installation directory.
#It may take a while to install the benchmarks.

5) Open a terminal and type,
cd cd $HOME/Scout/cpuspec/
source shrc
#Alternatively, run source cshrc

6) To test the installation, check the version,
runcpu --version
#This will display the summary of the versions of the utilities.

7) Copy the config files and the scripts to run CPU SPEC 2017 benchmarks with Scout,
cp $HOME/Scout/scripts/cpuspec/scripts/* $HOME/Scout/cpuspec/
cp $HOME/Scout/scripts/cpuspec/config/* $HOME/Scout/cpuspec/config/
chmod +x *.sh

NOTE: It is possible that some of the installed CPU SPEC 2017 benchmarks are not updated. In that case, the build phase for some benchmarks (such as 510.parest r) might fail. To update the CPU SPEC 2017 benchmarks, run the following commands,
cd $HOME/Scout/cpuspec/
source shrc
runcpu --update
#This may take a while.
#Comment the Wl-stack flag in clang.xml file.


Running CPU SPEC 2017 benchmarks
=====================================
cd $HOME/Scout/cpuspec/


To reproduce Table 1 in paper, run the following command,
./table1.sh

Description of the output: The first part of the output represents the memory overhead of the custom allocator MO for each benchmark (custom allocator, using bump allocator and replacing stack allocations with calls to malloc and free when the stack objects go out of scope). The second part represents the CPU overhead of the allocator CO for each benchmark (custom allocator, using bump allocator and replacing stack allocations with calls to malloc and free when the stack objects go out of scope).


To reproduce Table 5 in paper, run the following command,
./table5.sh

Description of the output: The first part of the output represents the number of versioned loops executed #Le. The second part of the output represents the number of loops versioned by Scout #La and the number of versioned loops that are vectorizable #Lb. The third part represents the performance benefits obtained when the benchmarks are compiled with Scout Pa.


To reproduce Table 6 in paper, run the following command,
./table6.sh

Description of the output: The output of this script represents the number of versioned loops based on the profiler’s feedback #Lp, number of versioned loops that are vectorizable #Lb and the performance benefits P a for different thresholds (of the loop’s execution time improvement) when the benchmarks are compiled using Scout and the profiler’s feedback. Currently, this script reports the results for threshold 0, 10, 20 and 30, as discussed in the paper. However, the user can customize the thresholds by updating the variable VAL in the build scripts.