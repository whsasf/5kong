#!/bin/bash

#calculate base64
echo "$Sanityuser@${default_domain}" >base64.tmp
echo "$Sanityuser" >passbase64.tmp
b64v=$(base64 base64.tmp)
b64v=$(echo $b64v | tr -d " ")

passbase64v=$(base64 passbase64.tmp)
passbase64v=$(echo $passbase64v | tr -d " ")

#smtp auth login testing
exec 3<>/dev/tcp/$MTAHost/$SMTPPort
echo -en "auth login\r\n" >&3
echo -en "$b64v\r\n" >&3
echo -en "$passbase64v\r\n" >&3
echo -en "QUIT\r\n" >&3
cat <&3 > auth_login.tmp
echo "========== the content of auth_login.tmp ==========" >>debug.log
cat auth_login.tmp >>debug.log
echo "===================================================" >>debug.log

outflag=$(grep -i "Authentication successful"  auth_login.tmp |wc -l)
echo "########## outflag=$outflag" >>debug.log
if [ "$outflag" -eq 1 ];then
	prints "auth_login_success successfully"  "SMTP_auth_login_success" 2
	Result=0
else
	prints "auth_login_success not successful" "SMTP_auth_login_success" 1
  Result=1
fi
summary "SMTP_AUTH:auth_login_success" $Result