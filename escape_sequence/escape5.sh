
contents=$(cat hello.txt; printf x)
contents=${contents%x}
#printf "%q\n" "$contents"

output=$(printf "%q\n" "$contents")
# escaping space also
#echo ${output/ /\\s} > escaped.txt
echo $output | sed 's/ /\\s/g' > escaped.txt

