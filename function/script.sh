## You cannot keep an empty function , that will likely give syntax error for no reason

function_n () {
   #Commands to be executed
ind=0
}

function function_exec {
   #Commands to be executed
inp=0
}


function_name () {
   #Commands to be executed
inc=0
value=$inc
#value=$(pwd)
#return $value
   echo $value
}

add_numbers () {
   num1=$1
   num2=$2
   sum=$((num1+num2))
   echo "The sum is: $sum"
}

add_numbers 10 20
function_name

var=$(add_numbers 10 20)


echo "Your place is ""$(function_name)"

echo "Variable "$var
