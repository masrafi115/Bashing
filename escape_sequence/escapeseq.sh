input_file="hello.txt"
output_file="escaped.txt"

# Dump the content of the input file in octal format and convert to escape sequences
od -t o1 -An $input_file | sed 's/ *//g; s/.\{2\}/\\x&/g' | xargs printf "%b" > $output_file

echo "Converted text written to $output_file"
