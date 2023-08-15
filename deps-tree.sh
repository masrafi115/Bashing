#!/bin/bash

# Function to recursively list dependencies and their depths
function listDependencies() {
    local package="$1"
    local depth="$2"

    # Print the package and its depth
    echo "$depth$package"

    # Get the dependencies of the package using yarn info
    local dependencies=$(yarn info "$package" --json | jq -r '.data.peerDependencies, .data.dependencies | keys[]')

    # Recursively list the dependencies with increased depth
    for dependency in $dependencies; do
        listDependencies "$dependency" "$depth  "
    done
}

# Check if the package name is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: bash script_name.sh <package-name>"
    exit 1
fi

# Call the function with the provided package name and initial depth of 0
listDependencies "$1" " "