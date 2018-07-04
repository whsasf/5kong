#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc

#Retrieves information from the MSS to describe the properties of a specified
#message store and its folders. This utility can be useful during migration and for
#other administrative purposes.

#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn  $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi
#deliever 2 messages
mail_send "$Sanityuser" "small" "2"
