contents="$(cat hello.txt; printf x)"
contents="${contents%x}"
echo "$contents" > escaped.txt