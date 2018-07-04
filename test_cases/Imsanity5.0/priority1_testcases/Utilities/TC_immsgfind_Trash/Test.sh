#!/bin/bash

immsgfind $Sanityuser@${default_domain} "$msg_id" "/Trash" > log_immsgfind1.tmp
chk_msg_id=$(cat log_immsgfind1.tmp | egrep -i "MESSAGE-ID" | wc -l)
chk_msg_id=`echo $chk_msg_id | tr -d " "`
echo "========== the content of log_immsgfind1.tmp ==========" >>debug.log
cat log_immsgfind1.tmp >> debug.log
echo "======================================================="  >>debug.log
echo "########## chk_msg_id=$chk_msg_id" >>debug.log
if [ "$chk_msg_id" == "1" ]
then
	prints "immsgfind utility is working fine" "TC_immsgfind_Trash" "2"
	Result="0"
else
	prints "ERROR: immsgfind utility output is not correct -'PT-57'" "TC_immsgfind_Trash" "1"
	Result="1"
fi

summary "UTILITIES:TC_immsgfind_Trash" $Result 