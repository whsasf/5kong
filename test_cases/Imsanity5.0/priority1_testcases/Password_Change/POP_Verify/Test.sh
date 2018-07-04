#!/bin/bash

#change password to secret
imdbcontrol setPassword $Sanityuser ${default_domain} haha clear

exec 3<>/dev/tcp/$POPHost/$POPPort
echo -en "user $Sanityuser\r\n" >&3
echo -en "pass haha\r\n" >&3
echo -en "list\r\n" >&3
echo -en "quit\r\n" >&3
cat <& 3 &> change_pwd.tmp
echo "========== the content of change_pwd.tmp ==========" >>debug.log
cat change_pwd.tmp >>debug.log
echo "===================================================" >>debug.log
verify_newpwd=$(cat change_pwd.tmp | grep "is welcome here" | wc -l)
echo "########## verify_newpwd=$verify_newpwd" >>debug.log
if [ "$verify_newpwd" == "1" ]
then
	prints "Password reset succesfully and POP login successfully" "password_change" "2"
	Result="0"
else
	prints "ERROR:Password is not reset succesfully or POP login failed" "password_change" "1"
	prints "ERROR: Please check Manually." "password_change" "1"	
	Result="1"
fi
echo "########## Password change succesfully" >> debug.log
summary "Password_change_POP_verify" $Result