#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc


#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn  $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi
immsgdelete $Sanityuser@${default_domain} -all 
#deliever 2 messages
$smpl  -u $Sanityuser   -f Trash -c 2  $message_template_1K
immssdescms $Sanityuser@${default_domain} > descms_Sanity1.tmp
msg_id=$(cat descms_Sanity1.tmp | grep -i "Message ID" | cut -d " " -f2 | cut -d "=" -f2 | tail -1)
msg_id=$(echo $msg_id | tr -d " ")
echo "########## msg_id=$msg_id" >>debug.log

