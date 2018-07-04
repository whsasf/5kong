#!/bin/bash

#calculate base64
#(1) create this perl script

#echo '#!/usr/bin/perl' >auth_plain_base64.pl
#echo 'use strict;'>>auth_plain_base64.pl
#echo 'use warnings;'>>auth_plain_base64.pl
#echo 'use MIME::Base64;'>>auth_plain_base64.pl
#echo "my \$source=\"\\0$Sanityuser\\@${default_domain}\\0$Sanityuser\";">>auth_plain_base64.pl
#echo 'my $out = encode_base64($source);'>>auth_plain_base64.pl
#echo 'print $out;'>>auth_plain_base64.pl

#echo "========== the content of auth_plain_base64.pl ==========" >>debug.log
#cat auth_plain_base64.pl >>debug.log
#echo "=========================================================" >>debug.log
#(2) add executive permission 
#chmod +x auth_plain_base64.pl
#(3) execute perl script to get the base64 date string
#perl auth_plain_base64.pl >auth_plain_base64.txt
#auth_plain_base64=$(cat auth_plain_base64.txt)
auth_plain_base64=xxxxxxxxxx
echo "########## auth_plain_base64=$auth_plain_base64" >>debug.log
#smtp auth login testing
exec 3<>/dev/tcp/$MTAHost/$SMTPPort
echo -en "auth plain\r\n" >&3
echo -en "$auth_plain_base64\r\n" >&3
echo -en "QUIT\r\n" >&3
cat <&3 > auth_plain.tmp
echo "========== the content of auth_plain.tmp ==========" >>debug.log
cat auth_plain.tmp >>debug.log
echo "===================================================" >>debug.log

outflag=$(grep -i "Authentication failed"  auth_plain.tmp |wc -l)
echo "########## outflag=$outflag" >>debug.log
if [ "$outflag" -eq 1 ];then
	prints "auth_plain_fail successfully"  "SMTP_auth_plain_fail" 2
	Result=0
else
	prints "auth_plain_fail not successful" "SMTP_auth_plain_fail" 1
  Result=1
fi
summary "SMTP_AUTH:auth_plain_fail" $Result