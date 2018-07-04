#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc
Sanityuser=test$(echo $RANDOM)

#create test account
#account_create_fn $Sanityuser
#use  curl to create account with passwordStoreType=clear to avoid restart mxos
curl -X PUT -v -H "Content-Type: application/x-www-form-urlencoded" -d "cosId=default&password=$Sanityuser&passwordStoreType=clear" "http://${mxoshost_port}/mxos/mailbox/v2/$Sanityuser@${default_domain}" &> log_account_create.tmp
echo "========== the content of log_account_create.tmp ==========" >>debug.log
cat log_account_create.tmp >>debug.log
echo "===========================================================" >>debug.log
imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	curl -X PUT -v -H "Content-Type: application/x-www-form-urlencoded" -d "cosId=default&password=$Sanityuser&passwordStoreType=clear" "http://${mxoshost_port}/mxos/mailbox/v2/$Sanityuser@${default_domain}" &> log_account_create.tmp
fi

#modify smtpauth attribute

ldap_modify_utility $Sanityuser replace mailsmtpauth 1
			 
			 
#set keys:
set_config_keys "/*/mta/requireAuthentication" "true"
set_config_keys "/inbound-standardmta-direct/mta/requireAuthentication" "true"
set_config_keys "/*/mta/allowCRAMMD5" "true" 

#prepare cram-md5.py

pythonhome=$(which python)
sed -i '1d' cram-md5.py
sed -i "1i\#!$pythonhome"  cram-md5.py