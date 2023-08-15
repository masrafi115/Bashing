input_file="hello.txt"
output_file="escaped.txt"

# Define the characters to escape
chars_to_escape="&<>\"'"

# Escape the characters in the input file and write to the output file
while IFS= read -r line; do
    for c in $(echo "$chars_to_escape" | fold -w1); do
        line=$(echo "$line" | sed "s/$c/\\$c/g")
    done
    echo "$line"
done < "$input_file" > "$output_file"

echo "Escaped text written to $output_file"