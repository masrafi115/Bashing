while IFS=$'\n' read line; do
    echo "Text read from file: $line"
done < file.txt