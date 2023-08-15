# Termux
# Increment Syntax
i=0
j=50
#((i++))
#((i+=1))
#((i=i+4))
#j=$((j++))
#j=$((++j))
for f in ../*.*
do
i=$((i+1))
echo $i
done
