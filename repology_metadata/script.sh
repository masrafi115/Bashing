#!/bin/bash

# Path to the file
packages="termux-package-all.txt"

# Loop through each package name and check in the repology
i=0
while read package_name; do
((++i))

    curl -s https://repology.org/api/v1/project/{$package_name}/ | jq '.[0]' >> metadata.txt
    echo $i" "$package_name
done < "$packages"