#!/bin/bash

./specrun_profiler.sh
echo "Threshold 0"
./profiler_improvement_0.sh
echo
echo "Threshold 10"
./profiler_improvement_10.sh
echo
echo "Threshold 20"
./profiler_improvement_20.sh
echo
echo "Threshold 30"
./profiler_improvement_30.sh

