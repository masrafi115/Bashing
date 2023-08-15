jq -n '[ inputs[] | { (.keys[0]): "" } ] | map( .[0] |= (.[1] | select(. != {})) )' $1
