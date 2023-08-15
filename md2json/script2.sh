names=$(ls *.md | jq -Rn '[inputs | { file: "\(.)" } ]')
echo $names > nanes.json
inc=0
for file in ./*.md; do  
cnt=$(cat $file); 
#iterating is not storing, its just reusing constant variable
#jq 'map(. + { "text": "'"$cnt"'" })' text.json > new.json
((inc++))
done
#transpose add
rm text.json
#rm tmp2.json