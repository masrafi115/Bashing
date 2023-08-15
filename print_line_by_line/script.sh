#!/bin/bash

# Path to the keyword file
keyword_file="keywords.txt"

# Loop through each keyword and check if it matches the text file
i=0
while read keyword; do
((++i))
    #if grep -qw "$keyword" "$text_file"; then
        #matches="$matches$keyword "
    #fi
    echo $i" "$keyword
done < "$keyword_file"

# Display the matching keywords
# echo "$matches"