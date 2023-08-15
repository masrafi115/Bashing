#trans :fr file://input.txt
#doesnt work, no difference, indents and space are gone

inc=0
while file in ./*.* 
do
    content=$(sed -e ':a;N;$!ba;s/\n/\\n/g' -e 's/ /\\s/g' -e 's/\t/\\t/g' ${file})
    echo " Yours :"$content
    #while read j; do
    translatedf=$(trans -brief -no-warn zh:en $content)
    # echo $translatedf
    #tr "[[:space:]]" " "
    unescaped=$(echo -e "$translatedf" | sed 's/\\s/ /')
    filename=$(trans -brief zh:en ${file} | sed 's/ /_/g')
    # echo $i
    # echo "seperator"
    #increment index
    let "inc=inc+1"
    echo $inc
    # without quoting $translated, it will look like a shit, completely code style change and all in one line
    echo -e "$translatedf" >> $filename
    #done
done 