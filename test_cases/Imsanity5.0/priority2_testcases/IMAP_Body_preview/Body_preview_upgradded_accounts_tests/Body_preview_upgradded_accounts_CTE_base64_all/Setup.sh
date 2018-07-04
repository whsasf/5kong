#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc
#body preview key disable	
set_config_keys "/*/common/enableXFIRSTLINE" "false"

#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi


immsgdelete  $Sanityuser@${default_domain}  -all 

