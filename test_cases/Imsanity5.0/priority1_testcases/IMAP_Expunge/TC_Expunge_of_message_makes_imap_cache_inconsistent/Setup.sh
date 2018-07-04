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


immsgdelete $Sanityuser@${default_domain} -all 
#deliever 2 messages

#enable imap trace
set_config_keys "/*/common/traceOutputLevel" "imap=5" "0" 
mail_send "$Sanityuser" "small" "2"

#add deleted tag for message 1
exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "a login $Sanityuser $Sanityuser\r\n" >&3
echo -en "a select INBOX\r\n" >&3
echo -en "a store 1 +flags (\Deleted)\r\n" >&3
echo -en "a logout\r\n" >&3
cat <&3 >addflag.tmp
echo "========== the content of addflag.tmp==========" >>debug.log
cat addflag.tmp >>debug.log
echo "===============================================" >>debug.log
#clear imapserv.trace
> $INTERMAIL/log/imapserv.trace
