#!/bin/bash


large_message_send  "$Sanityuser"  "$msg_10mb"   "10MB" "$message_template_10MB"
echo "########## msgs_user =$msgs_user" >>debug.log 
if [ "$msgs_user" == "1" ];then
      if [ $msgs_stored -gt $msgs_size ]
      then
           prints $msgs_user" Mails were delivered successfully." "large_msg_delivery_10MB" "2"
           summary "10MB_message_delivery" 0
      else 
           prints "Total Bytes Stored is $msgs_stored : which should be greater than $msgs_size" "large_msg_delivery_10MB" "1"
           summary "10MB_message_delivery" 1 
      fi
else
      
      prints "ERROR: "$msgs_user" Mails were delivered only." "large_msg_delivery_10MB" "1"
      prints "ERROR: Mails delivery failed. Please check this Manually." "large_msg_delivery_10MB" "1"
      summary "10MB_message_delivery" 1
fi
        
#prints "100KB Message Delivery Sessions Ends." "large_msg_delivery" 
       					
