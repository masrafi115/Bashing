StringVal="Welcome to linuxhint"

# Iterate the string variable using for loop
for val in $StringVal; do
 echo $val
done

for i in ${StringVal[@]}
do
  echo 'word---'$i
done

