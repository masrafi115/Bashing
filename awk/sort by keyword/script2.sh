{ grep "x11" $1; grep -v "x11" $1; } | awk '!a[$1]++'
