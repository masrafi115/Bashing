#!bin/sh
echo "Hello"
{
        echo '  directory "/var/cache/bind";'
        echo '  listen-on { 127.0.0.1; };'
        echo '  listen-on-v6 { none; };'
        echo '  version "";'
        echo '  auth-nxdomain no;'
        echo '  forward only;'  
        echo '  forwarders { 8.8.8.8; 8.8.4.4; };'
        echo '  dnssec-enable no;'
        echo '  dnssec-validation no;'
} >> file.txt