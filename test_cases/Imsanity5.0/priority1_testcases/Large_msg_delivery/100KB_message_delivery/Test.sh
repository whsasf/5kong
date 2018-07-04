#!/bin/bash

large_message_send  "$Sanityuser"  "$msg_100kb"   "100KB" "$message_template_100K"
echo "########## msgs_user=$msgs_user" >>debug.log
if [ "$msgs_user" == "1" ];then
      if [ $msgs_stored -gt $msgs_size ]
      then
           prints $msgs_user" Mails were delivered successfully." "large_msg_delivery_100KB" "2"
           summary "100KB_message_delivery" 0
      else 
           prints "Total Bytes Stored is $msgs_stored : which should be greater than $msgs_size" "large_msg_delivery_100KB" "1"
           summary "100KB_message_delivery" 1 
      fi
else
      
      prints "ERROR: "$msgs_user" Mails were delivered only." "large_msg_delivery_100KB" "1"
      prints "ERROR: Mails delivery failed. Please check this Manually." "large_msg_delivery_100KB" "1"
      summary "100KB_message_delivery" 1
fi
        
#prints "100KB_message_delivery Sessions Ends." "large_msg_delivery" 
       					
