#not possible because it will create temporary files but nmm won't permit instead of real file

cat <<EOM >hello.txt
text1
text2 # This comment will be inside of the file.
The keyword EOM can be any text, but it must start the line and be alone.
 EOM # This will be also inside of the file, see the space in front of EOM.
EOM # No comments and spaces around here, or it will not work.
text4 
EOM

cat << EOF > hello.txt
text1
text2 # This comment will be inside of the file.
The keyword EOM can be any text, but it must start the line and be alone.
 EOM # This will be also inside of the file, see the space in front of EOM.
EOM # No comments and spaces around here, or it will not work.
text4 
EOF