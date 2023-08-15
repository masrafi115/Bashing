#!/bin/bash

# URL of the package

# Function to download the zipball
download_zipball() {
    local zipball_url="$1"
    local filename="${zipball_url##*/}"

    echo "Downloading $filename..."
    curl -L -o "$filename.zip" "$zipball_url"
    echo "Download complete!"
}

# Main script
main() {
    var="1.0.2"
    package="doctrine/lexer"
    URL="https://packagist.org/packages/$package.json"
    # Get the JSON data from the URL
    json_data=$(curl -s "$URL")
    
    # Extract the zipball URL using jq
    zipball_url=$(echo "$json_data" | jq -r ".package.versions.\"$var\".dist.url")

    # Check if zipball_url is not empty
    if [ -n "$zipball_url" ]; then
        echo "Zipball "$zipball_url
        download_zipball "$zipball_url"
    else
        echo "Error: Unable to retrieve zipball link from the URL."
    fi
}
main
