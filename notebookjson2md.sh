
inc=0
jq -r '.[] | "\(.title)"' $1 | while read j; do
    # here j is all the titles
    # do stuff with $i
    # were getting text field value from json seperately by index
    i=$(jq -r '.['"$inc"'] | "\(.text)"' $1)
    ctg_num=$(jq -r '.['"$inc"'] | "\(.folder)"' $1)
    ctg=${folder_list[$ctg_num]}
    date_cr=$(jq -r '.['"$inc"'] | "\(.created_date)"' $1)
    # echo $i
    # echo "seperator"
    #increment index
    ((inc++))
    echo $inc
    echo -e "$date_cr"."\n"."#"."$ctg"."\n"."$i" >> $ctg/$j.md
    #echo $i$j.md
done
