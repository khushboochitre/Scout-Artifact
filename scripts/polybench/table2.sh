#!/bin/bash

echo "Column 2"
./polybench_cpu_overhead.sh #fourth column
echo
echo "Column 3"
./polybench_cpu_overhead_aligned.sh #fifth column 
echo
echo "Column 4"
./polybench_mem_overhead.sh #second column
echo
echo "Column 5"
./polybench_mem_overhead_aligned.sh #third column
