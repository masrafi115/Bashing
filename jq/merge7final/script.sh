jq -n '[inputs] | transpose | map(add)' $1 $2