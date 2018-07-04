#!/bin/bash

## CHECKING FLAGS THRUGH IMAP 
#first session
prints "Checking flag through IMAP" "RECENT_flag_is_set_in_first_session" 
exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "a login $Sanityuser2 $Sanityuser2\r\n" >&3
echo -en "a select INBOX\r\n" >&3
echo -en "a logout\r\n" >&3
cat <&3 > temporary.tmp
recent=$(cat temporary.tmp |grep -i "recent" |cut -d " " -f2)
recent=`echo $recent | tr -d " "`
echo "########## recent=$recent" >>debug.log
if [ "$recent" == "1" ]
then
   	prints " Flag is Recent ..." "RECENT_flag_is_set_in_first_session" "2"
   	Result=0
else
    prints " ERROR : Flag is not Recent ..." "RECENT_flag_is_set_in_first_session" "1"
    Result=1
fi
summary "RECENT_flag_is_set_in_first_session" $Result
