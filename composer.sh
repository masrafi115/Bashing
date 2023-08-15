#!/bin/bash

# Define the path to the composer.json file
COMPOSER_JSON_PATH="./composer.json"

# Define a function to recursively get the dependencies for a package
function get_package_dependencies() {
    local package_name=$1
    local package_version=$2
    local indent=$3
    
    # Skip the "php" package
    if [[ "${package_name}" = "php" || "${package_name}" =~ ^ext- ]]; then
        return
    fi
    
    # Print the package name and version
    echo "${indent}${package_name} (${package_version})"

    # Get the package information from Packagist
    
    local packagist_url="https://packagist.org/packages/${package_name}.json"
    echo $packagist_url
    local packagist_response=$(curl -s "${packagist_url}")
    
    # Check if the response is null or empty
    if [[ -z "${packagist_response}" ]]; then
        return
    fi

    # Parse the dependencies
    #echo "Parse Test"
    #echo ${packagist_response}
    local dependencies=$(echo "${packagist_response}" | jq -r '.package.versions | .[keys_unsorted[0]].require | keys[]')
    #echo "Parse Finish"
    # Recursively get the dependencies for each dependency
    for dependency in ${dependencies}; do
        echo $dependency
        local dependency_version=$(echo "${packagist_response}" | jq -r ".package.versions | .[keys_unsorted[0]].require.\"${dependency}\"")
        echo $dependency_version
        get_package_dependencies "${dependency}" "${dependency_version}" "${indent}    "
    done
}

# Get the root package information from composer.json
root_package=$(jq -r '.name,.version' "${COMPOSER_JSON_PATH}")

# Print the root package information
echo "${root_package}"

# Get the root package dependencies
root_dependencies=$(jq -r '.require | keys[]' "${COMPOSER_JSON_PATH}")

# Recursively get the dependencies for each root dependency
for dependency in ${root_dependencies}; do
    dependency_version=$(jq -r ".require.\"${dependency}\"" "${COMPOSER_JSON_PATH}")
    
    # Get the latest version of the dependency from Packagist
    #latest_version=$(curl -s "https://packagist.org/packages/${dependency}/${dependency}.json" | jq -r '.package.[]')

    # Get the dependencies for the latest version of the dependency
    get_package_dependencies "${dependency}" "${dependency_version}" "    "
done
