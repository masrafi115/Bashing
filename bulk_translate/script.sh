#!/bin/bash
for i in ./*.*
do
    mv -i "$i" "$(echo ${i} | trans -brief zh:en | sed 's/ /_/g')"; 
done