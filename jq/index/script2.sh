jq -r '[to_entries[] | {(.key+1|tostring): .value}] | add' $1
