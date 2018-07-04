#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc

#create test accounts
Sanityuser1=test$(echo $RANDOM)
Sanityuser2=test$(echo $RANDOM)
account_create_fn $Sanityuser1
imboxstats $Sanityuser1@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser1
fi

account_create_fn $Sanityuser2
imboxstats $Sanityuser2@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser2
fi
#create new folder in $Sanityuser1
imap_create "$Sanityuser1" "New_folder"
imap_append "$Sanityuser1" "New_folder" "{9}" "ccvbnjhyt"

shareFolder "$mxoshost_port" "$Sanityuser1" "$Sanityuser2"  "New_folder"
#imctrl  allhosts  killStart mss   &> restart.txt
sleep 5
imap_fetch "$Sanityuser2" "1" "rfc822" "$Sanityuser1-New_folder"

