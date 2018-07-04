#!/bin/bash

#change password to secret
imdbcontrol setPassword $Sanityuser ${default_domain} secret clear

exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "a login $Sanityuser secret\r\n" >&3
echo -en "a logout\r\n" >&3
cat <& 3 &> change_pwd.tmp
echo "========== the content of change_pwd.tmp ==========" >>debug.log
cat change_pwd.tmp >>debug.log
echo "===================================================" >>debug.log
verify_newpwd=$(cat change_pwd.tmp | grep "OK LOGIN completed" | wc -l)
echo "########## verify_newpwd=$verify_newpwd" >>debug.log
if [ "$verify_newpwd" == "1" ]
then
	prints "Password reset succesfully and IMAP login successfully with new password" "password_change" "2"
	Result="0"
else
	prints "ERROR:Password is not reset succesfully or IMAP login failed with new password" "password_change" "1"
	prints "ERROR: Please check Manually." "password_change" "1"	
	Result="1"
fi
echo "########## Password change succesfully" >> debug.log
summary "Password_change_IMAP_verify" $Result