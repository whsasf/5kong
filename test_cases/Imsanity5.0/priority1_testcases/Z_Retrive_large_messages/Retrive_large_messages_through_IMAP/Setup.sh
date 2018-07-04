#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc


#create test account
#set_config_keys "/*/common/mailFolderQuotaEnabled" "true" "1"
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

immsgdelete $Sanityuser@${default_domain} -all 

sleep 15
imdbcontrol sac $Sanityuser ${default_domain} mailquotamaxmsgkb 0
imdbcontrol sac $Sanityuser ${default_domain} mailquotatotkb 0


msg_10mb=$(cat $message_template_10MB)

SUBJECT="10MB message sending test"
large_message_send  "$Sanityuser"  "$msg_10mb"   "10MB" "$message_template_10MB"
echo "########## msgs_user=$msgs_user" >>debug.log
if [ "$msgs_user" == "1" ];then
      if [ $msgs_stored -gt $msgs_size ]
      then
           prints $msgs_user" Mails were delivered successfully." "large_msg_delivery_10MB" "2"
           #summary "10MB message delivery" 0
           goon=1
      else 
           prints "Total Bytes Stored is $msgs_stored : which should be greater than $msgs_size" "large_msg_delivery_10MB" "1"
           #summary "10MB message delivery" 1 
           goon=0
      fi
else
      
      #prints "ERROR: "$msgs_user" Mails were delivered only." "large_msg_delivery_10MB" "1"
      prints "ERROR: Mails delivery failed. Please check this Manually." "large_msg_delivery_10MB" "1"
      #summary "10MB message delivery" 1
fi