#1
echo $PATH | tr ':' '\n' | xargs -n 1 ls -1

#2
(IFS=': '; ls -1 $PATH)

#3
function command-search
{
   oldIFS=${IFS}
   IFS=":"

   for p in ${PATH}
   do
      ls $p | grep $1
   done

   export IFS=${oldIFS}
}

#4
ls $(echo $PATH | tr ':' ' ') | grep -v '/' | grep . | sort