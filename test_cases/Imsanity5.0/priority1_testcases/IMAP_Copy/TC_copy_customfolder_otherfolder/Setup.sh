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

immsgdelete  $Sanityuser@${default_domain}  -all 

#deliever 4 messages 
mail_send "$Sanityuser" "small" "4"
imap_create "$Sanityuser" "folder1"
imap_create "$Sanityuser" "folder2"
imap_copy "$Sanityuser" "3" "folder1" "INBOX"

