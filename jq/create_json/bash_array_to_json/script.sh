data=("hey" "whats" "up")
jq -c -n '$ARGS.positional' --args "${data[@]}" > tmp.json
#jq -n --arg bn "$data" '{text: $bn}'
#echo "Hi".${data[0]};
#for i in data do
#echo ${data[@]}
#jq -n --arg bh "${data[@]}" '{text: $bh}' 
#done