#!/bin/bash


#(1) add executive permission to cram-md5.py
chmod +x cram-md5.py

#(2)telnet to SMTP server to run auth cram-md5

exec 3<>/dev/tcp/$MTAHost/$SMTPPort
read ok line <&3
echo -en "auth cram-md5\r\n" >&3
read ok line <&3
#echo $ok
#echo $line
#wrong challenge number
challenge="PDIwMTcwOTA0MTQyNTM0LklFWDI2NzU4Lm14LTEwLTQ5LTU4LTEyNy5vcGVud2F2ZS5jb21AWzEwLjQ5LjU4LjEyN10+"
echo "########## challenge=$challenge" >>debug.log
#calculate cram-md5
./cram-md5.py "$Sanityuser@${default_domain}"  "$Sanityuser"  "$challenge" >digestvalue.tmp
digestvalue=$(cat digestvalue.tmp |head -n 1)
digestvalue=$(echo $digestvalue | tr -d " ")
echo "########## digestvalue=$digestvalue" >>debug.log
#continue smtp auth process
echo -en "$digestvalue\r\n" >&3
read ok line <&3
#echo $ok
#echo $line
echo -en "QUIT\r\n" >&3
#cat <&3 > 
echo $line >auth_cram-md5.tmp
echo "========== the content of auth_cram-md5.tmp ==========" >>debug.log
cat auth_cram-md5.tmp >>debug.log
echo "===================================================" >>debug.log

#outflag=$(grep -i "Authentication failed"  auth_cram-md5.log |wc -l)
outflag=$(echo $line |grep -i "Authentication failed"|wc -l)
echo "########## outflag=$outflag" >>debug.log
if [ "$outflag" -eq 1 ];then
	prints "auth_cram-md5_fail successfully"  "SMTP_auth_cram-md5_fail" 2
	Result=0
else
	prints "auth_cram-md5_fail not successful" "SMTP_auth_cram-md5_fail" 1
  Result=1
fi
summary "SMTP_AUTH:auth_CRAM-MD5_fail" $Result