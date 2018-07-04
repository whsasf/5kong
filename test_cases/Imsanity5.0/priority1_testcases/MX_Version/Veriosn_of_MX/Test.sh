#!/bin/bash
> debug.log
> summary.log
start_time_tc
msg_msg_ver1=$(imconfget -localconfig InterMailVersion | grep "$msg_msg_ver" | wc -l)	
echo "########## msg_msg_ver1=$msg_msg_ver1"  >>$debuglog						
if [ $msg_msg_ver1 == "1" ]
then
	prints "Version of the MX is : $msg_msg_ver2 $msg_msg_ver3 " "Veriosn_of_MX" "2"
	Result="0"
	#echo 
else					
	prints "ERROR: We are not able to find MX version" "Veriosn_of_MX" "1"
	#echo
	prints "ERROR: Please check Manually." "Veriosn_of_MX" "1"
	Result="1"
fi
summary "Veriosn_of_MX" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog