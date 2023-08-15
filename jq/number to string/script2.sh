jq '[ .[] | .page = (.page | tostring) ]' $1
