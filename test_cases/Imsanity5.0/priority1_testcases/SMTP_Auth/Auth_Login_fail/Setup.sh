#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc
Sanityuser=test$(echo $RANDOM)
#create test account
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

#modify smtpauth attribute

ldap_modify_utility $Sanityuser replace mailsmtpauth 1
			 
			 
#set keys:
set_config_keys "/*/mta/requireAuthentication" "true"
set_config_keys "/inbound-standardmta-direct/mta/requireAuthentication" "true"
