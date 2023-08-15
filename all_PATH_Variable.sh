#!/bin/bash
echo $PATH  | tr : '\n' | 
while read e; do 
    for i in $e/*; do
        if [[ -x "$i" && -f "$i" ]]; then     
            echo $i
        fi
    done
done
