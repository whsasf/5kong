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

sleep 15
#account quota settings
imdbcontrol sac $Sanityuser ${default_domain} mailquotamaxmsgkb 0
imdbcontrol sac $Sanityuser ${default_domain} mailquotatotkb 0

#delete messages
immsgdelete  $Sanityuser@${default_domain}  -all 
