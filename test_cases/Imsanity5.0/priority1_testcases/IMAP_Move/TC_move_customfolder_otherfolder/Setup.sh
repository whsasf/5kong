#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc


#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser
imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

immsgdelete  $Sanityuser@${default_domain} -all 

mail_send "$Sanityuser" "small" "4"
imap_create "$Sanityuser" "folder11"
imap_create "$Sanityuser" "folder2"
imap_move "$Sanityuser" "3" "folder11" "INBOX"


