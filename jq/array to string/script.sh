jq '[ .[] | .verses_en = (.verses | tostring) ] | del(.[].verses)' $1