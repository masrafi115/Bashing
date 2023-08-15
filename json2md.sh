inc=0
jq -r '.[] | "\(.title)"' $1 | while read j; do
    # here j is all the titles
    # do stuff with $i
    # were getting text field value from json seperately by index
    i=$(jq -r '.['"$inc"'] | "\(.text)"' $1)
    echo $i
    # echo "seperator"
    #increment index
    ((inc++))
    echo $inc
    echo -e "$i" >> $j.md
    #echo $i$j.md
done
