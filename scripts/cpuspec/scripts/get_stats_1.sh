#!/bin/bash
file_names="$HOME/Scout/SPEC/files_spec_1.txt"
BENCHMARK="$HOME/Scout/SPEC"

while IFS= read -r file;
do
        loops_benefited=0
        loops_new_vect=0

        for input in $file
        do
                input="$BENCHMARK/benchspec/CPU/$input"
                echo $input
                while IFS= read -r line;
                do
                        if [[ "$line" == *"Number of loops benefited"* ]]; then
                                count=` echo $line | sed 's/[^0-9]*//g'`
                                loops_benefited=`echo "$loops_benefited+$count" | bc`
                        elif [[ "$line" == *"Number of newly vectorized loops"* ]]; then
                                count=` echo $line | sed 's/[^0-9]*//g'`
                                loops_new_vect=`echo "$loops_new_vect+$count" | bc`
                        fi
                done < "$input"
        done

        echo $file
        echo "Total number of versioned loops $loops_benefited"
        echo "Total number of versioned loops that are vectorizable $loops_new_vect"
done < $file_names
