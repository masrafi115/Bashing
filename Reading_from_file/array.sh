# declaring array list and index iterator
declare -a array=()
i=0

# reading file in row mode, insert each line into array
while IFS=$"\n" read -r line; do
    array[i]=$line
    let "i++"
    # reading from file path
done < file.txt


for line in "${array[@]}"
  do
    echo "$line"
  done