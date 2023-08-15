#!/bin/bash

# Define the function
get_greeting () {
  local name=$1
  local greeting="Hello, $name!"
  echo "$greeting"
}

# Call the function and store the result in a variable
result=$(get_greeting "John")

# Output the result
echo "Result is ""$result"
