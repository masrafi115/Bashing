jq '[ .[] | .page = (.page | tonumber) ]' $1
