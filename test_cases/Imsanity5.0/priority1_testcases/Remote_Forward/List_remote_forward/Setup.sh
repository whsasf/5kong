#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc


#create test account
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

immsgdelete $Sanityuser1@${default_domain} -all 
immsgdelete $Sanityuser2@${default_domain} -all 

#create forward
create_remote_fwd $Sanityuser1 $Sanityuser2	



