
   BEGIN { FS = "" } # Set the field separator to an empty string to process each character separately
   {
       for (i = 1; i <= NF; i++) {
           # Use the Linux "trans" command to translate each character from Chinese to English
           # Replace "zh" with the language code for your input language
           # Replace "en" with the language code for your target language
           cmd = "trans -brief -no-auto -s zh -t en \"" $i "\""
           if ((cmd | getline result) > 0) {
               # If the translation succeeded, print the result
               printf("%s", result)
           } else {
               # If the translation failed, print the original character
               printf("%s", $i)
           }
           close(cmd)
       }
       printf("\n") # Print a newline after each line
   }
   
