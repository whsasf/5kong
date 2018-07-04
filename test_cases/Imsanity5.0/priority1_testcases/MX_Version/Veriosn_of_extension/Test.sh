#!/bin/bash
> debug.log
> summary.log
start_time_tc
ext=$($INTERMAIL/lib/imextserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "########## ext=$ext" >>$debuglog
if [ $ext == "1" ]
then 
		prints "Verions of the ext is : $msg_msg_ver2 $msg_msg_ver3  " "Veriosn_of_extension" "2"
		Result="0"
		else	
		prints "ERROR: We are not able to find extension server version" "Veriosn_of_extension" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_extension" "1"
		Result="1"
fi
summary "Version_of_extension" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog