#same, it will try to create temporary file and nmm won't permit

tee -a hello.txt << END
Host localhost
  ForwardAgent yes
END