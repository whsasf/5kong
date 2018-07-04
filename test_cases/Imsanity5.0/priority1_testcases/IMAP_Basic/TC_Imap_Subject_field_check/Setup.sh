#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc
Sanityuser=test$(echo $RANDOM)
#create test account
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi


immsgdelete $Sanityuser@${default_domain} -all 
#deliever 5 messages
mail_send "$Sanityuser" "small" "5"
#imap uid check
imap_uid_check $Sanityuser


user_mail_name=$(whoami)
MAILFROM=`imdbcontrol la | grep -i @ | grep -i $user_mail_name | cut -d ":" -f2 | cut -d "@" -f1`
MAILFROM=`echo $MAILFROM | tr -d " "`
