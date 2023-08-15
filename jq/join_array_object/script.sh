#param 2 must be array of value only
#sh script.sh new.json tmp.json
jq -n '[inputs] | transpose | map({text:.[0] })' $2 >> inter.json
jq -n '[inputs] | transpose | map(add)' $1 inter.json
rm inter.json