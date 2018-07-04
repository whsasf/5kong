#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
#taking start time of tc  
start_time_tc
      
#create account
Sanityuser=test$(echo $RANDOM)
account_create_fn  $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

#send 6 messages
mail_send "$Sanityuser" "small" "6"
