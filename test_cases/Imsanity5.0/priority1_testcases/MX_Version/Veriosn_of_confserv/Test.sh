#!/bin/bash
> debug.log
> summary.log
start_time_tc
confserv=$($INTERMAIL/lib/imconfserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "########## confserv=$confserv" >>$debuglog
if [ $confserv == "1" ]
then
		prints "Verions of the confserv : $msg_msg_ver2 $msg_msg_ver3 " "Veriosn_of_confserv" "2"
		Result="0"
else
		prints "ERROR: We are not able to find confserv version" "Veriosn_of_confserv" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_confserv" "1"
		Result="1"
fi
summary "Version_of_confserv" $Result

cat debug.log   >> $debuglog
cat summary.log >> $summarylog
