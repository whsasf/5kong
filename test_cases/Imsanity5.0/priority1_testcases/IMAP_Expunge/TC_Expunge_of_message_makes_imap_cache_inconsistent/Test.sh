#!/bin/bash

imap_expunge $Sanityuser

msg_count1=$(cat $INTERMAIL/log/imapserv.trace | grep "expungeMsgCache" | wc -l) 
msg_count=$(cat $INTERMAIL/log/imapserv.trace | grep "unknown message" | wc -l)
echo "========== the content of imapserv.trace ==========" >>debug.log
cat $INTERMAIL/log/imapserv.trace  >>debug.log
echo "===================================================" >>debug.log
echo "########## msg_count=$msg_count" >>debug.log
echo "########## msg_count1=$msg_count1" >>debug.log
if [[ "$msg_count" == "1" && "$msg_count1" != "0" ]]
then
	prints " Expunge of message makes imap cache inconsistent. Please check manually." "expunge_cache_inconsistence" "1"
	Result="1"
else
	prints " Expunge of message does not make imap cache inconsistent." "expunge_cache_inconsistence" "2"
	Result="0"

fi 
#end_time_tc expunge_cache_inconsistence_tc
summary "IMAP:Expunge_of_message_makes_imap_cache_inconsistent" $Result

	
