#param 2 must be array of value only
#sh script.sh new.json tmp.json
jq -n 'map(.translations.text :(.))' result.json array.json

#rm inter.json