jq -s 'add | unique_by(.text) | map(.[].text)' $1 $2