#!/bin/bash
> debug.log
> summary.log
start_time_tc
mss=$($INTERMAIL/lib/mss -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "mss=$mss" >>$debuglog
if [ $mss == "1" ]
then
		prints "Version of the mss is : $msg_msg_ver2 $msg_msg_ver3   " "Veriosn_of_mss" "2"
		Result="0"
else		
		prints "ERROR: We are not able to find mss version" "Veriosn_of_mss" "1"
		prints "ERROR: Please check Manually." "MXVERSION" "1"
		Result="1"
fi
summary "Version_of_mss" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog