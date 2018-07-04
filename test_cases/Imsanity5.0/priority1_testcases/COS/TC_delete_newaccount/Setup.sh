#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc
#create cos bogus
create_cos bogus
#create account based on new cos:bogus 
Sanityuser=test$(echo $RANDOM)

account_create_fn $Sanityuser bogus

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser bogus
fi


