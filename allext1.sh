# [^.]: exclude dotfiles
find * | awk -F . {'print $2'} | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -rn