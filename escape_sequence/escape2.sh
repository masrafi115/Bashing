#!/bin/bash

# Define the input and output file paths
input_file="hello.txt"

# Define the characters to escape
chars_to_escape="&<>\"'"

# Escape the characters in the input file and write to the output file
sed "s/[${chars_to_escape}]/\\\\&/g" "$input_file" > escaped.txt