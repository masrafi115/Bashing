echo -e '["a","b"]\n["c","d"]' | jq -s 'add'
#echo -e '["a","b"]\n["c","d"]' | jq -s 'flatten(1)'
#echo -e '["a","b"]\n["c","d"]' | jq -s 'map(.[])'
#echo -e '["a","b"]\n["c","d"]' | jq -s '[.[][]]'
#echo -e '["a","b"]\n["c","d"]' | jq '.[]' | jq -s
