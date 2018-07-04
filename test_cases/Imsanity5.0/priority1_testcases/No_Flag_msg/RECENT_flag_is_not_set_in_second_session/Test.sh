#!/bin/bash

## CHECKING FLAGS THRUGH IMAP 

#second session	
prints "Checking flags through IMAP" "RECENT_flag_is_not_set_in_second_session" 
exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "a login $Sanityuser2 $Sanityuser2\r\n" >&3
echo -en "a select INBOX\r\n" >&3
echo -en "a logout\r\n" >&3
cat <&3 > temporary.tmp

recent=$(cat temporary.tmp |grep -i "recent" |cut -d " " -f2)
recent=`echo $recent | tr -d " "`
echo "########## recent=$recent" >>debug.log
if [ "$recent" == "0" ]
then
  prints " Flag is not Recent ..." "RECENT_flag_is_not_set_in_second_session" "2"
	prints " Utility is working fine " "RECENT_flag_is_not_set_in_second_session" "2"
	summary "RECENT_flag_is_not_set_in_second_session" 0
	
else
	prints " ERROR : Flag is Recent ..." "RECENT_flag_is_not_set_in_second_session" "1"
	prints " ERROR : Utility is not working " "RECENT_flag_is_not_set_in_second_session" "1"
	summary "RECENT_flag_is_not_set_in_second_session" 1
fi
