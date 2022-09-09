#!/bin/bash

echo "Column 2"
./specrun_mem_overhead.sh  #second column
echo
echo "Column 3"
./specrun_mem_bump_overhead.sh  #third column
echo
echo "Column 4"
./specrun_mem_malloc_overhead.sh  #fourth column
echo
echo "Column 5"
./specrun_cpu_overhead.sh  #fifth column
echo
echo "Column 6"
./specrun_cpu_bump_overhead.sh  #sixth column
echo
echo "Column 7"
./specrun_cpu_malloc_overhead.sh  #seventh column
