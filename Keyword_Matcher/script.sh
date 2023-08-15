#!/bin/bash

# Path to the text file
text_file="contents.txt"

# Path to the keyword file
keyword_file="keywords.txt"

# Loop through each keyword and check if it matches the text file
matches=""
while read keyword; do
    if grep -i -q -w "$keyword" "$text_file"; then
#echo "Matched"
        matches="$matches$keyword "
    fi
done < "$keyword_file"

# Display the matching keywords
echo "$matches"

