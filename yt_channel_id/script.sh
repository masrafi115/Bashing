#!/bin/bash

# Define the URL of the webpage
URL="https://m.youtube.com/@TEDEd"

# Fetch the webpage using curl
html=$(wget -qO- "$URL")

# Extract the channel ID using regular expressions and command-line tools
channel_id=$(echo "$html" | grep -oP '<meta itemprop="identifier" content="\K[^"]+')

# Print the channel ID
echo "Channel ID: $channel_id"
