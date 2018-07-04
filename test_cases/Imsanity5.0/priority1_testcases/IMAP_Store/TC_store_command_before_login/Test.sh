#!/bin/bash

prints "Store command not available in Non-Authenticated state " "stored_command_before_login" 2
exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "store 1:* FLAGS (\Seen)\r\n" >&3
echo -en "a logout\r\n" >&3
cat <&3 > mail.tmp
echo "========== the content of mail.tmp ==========" >>debug.log
cat  mail.tmp >>debug.log
echo "=============================================" >>debug.log

msg=$(cat mail.tmp | grep "BAD Unrecognized command, please login" | wc -l)
echo "########## msg=$msg" >>debug.log
if [ "$msg" == "1" ]
		then										
			prints "Giving proper error" "stored_command_before_login" "2"
			Result="0"
		else										
			prints "ERROR:Not giving proper error message. Please check manually." "stored_command_before_login" "1"										
			Result="1"
fi
	
summary "IMAP:Store_command_not_available_in_Non-Authenticated_state" $Result
