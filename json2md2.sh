jq -r '.[] | "\(.text) \(.title)"' $1 | while read i j; do
    # do stuff with $i
    # echo $i
    echo -e "$i" >> $j.md
    #echo $i$j.md
done