#!/bin/bash
declare -a names=("foo" "bar")
for it in ${names[@]}; do
    mapfile -t StringArray < <(exec rosmsg package ${it})
    echo $it
    for i in ${StringArray[@]}; 
        do echo $i;rosmsg md5 ${i};
    done
done
