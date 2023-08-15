#trans :fr file://input.txt
#doesnt work, no difference, indents and space are gone
get_escape () {
# dont replace to \n, \t instead \|nl and \|nt because translator automatically unescap
result=$(sed -e ':a;N;$!ba;s/\n/(pn)/g' -e 's/ /\\s/g' -e 's/\t/(jt)/g' $1)
echo $result
}
get_unescape () {
#doesn't work unexpected
output=$(echo $1 | sed -e 's/\\pn/\\n/g' -e 's/\\s/ /g' -e 's/\\jt/\\t/g' )
echo $output
}
inc=0
for file in ./*.cpp
do
#the main problem is when we give input from sed replacement, it doesn't work properly
#maybe the sed doesn't work in loop well
    content=$(get_escape $file)
    
    # escaping through external script will make again unga bunga
    #content=$(sh escape.sh $file)
    
    #content=$(cat "$file")
    # echo " Input  :"$content > "inter_"'$file'
    #while read j; do
    translatedf=$(trans -no-auto -no-ansi -brief zh:en $content)
    # text becoming unga bunga after translation, tried and debugged all
    # echo " Translated :"$translatedf > "inter_"'$file'
    #tr "[[:space:]]" " "
    
    unescaped=$(echo $translatedf | sed -e 's/(jt)/\\t/g' -e 's/(pn)/\\n/g'  -e 's/\\s/ /g')
    filename=$(trans -brief zh:en $file | sed 's/ /_/g')
    # echo $i
    # echo "seperator"
    #increment index
    inc=$((inc+1))
    echo $inc
    # without quoting $translated, it will look like a shit, completely code style change and all in one line
    echo $unescaped > $filename
    #done
done 


