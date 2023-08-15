filename=file.txt
IFS=$'\n'
for next in `cat $filename`; do
    echo "$next" 
done
exit 0


