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
#create new folder in test5
imap_create "$Sanityuser1" "New_folder"
imap_append "$Sanityuser1" "New_folder" "{9}" "ccvbnjhyt"

#with key enabled:/*/mxos/returnUserNameWithDomain
set_config_keys "/*/mxos/returnUserNameWithDomain" "true"
sleep 1

