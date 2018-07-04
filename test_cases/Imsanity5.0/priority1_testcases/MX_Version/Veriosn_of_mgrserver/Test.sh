#!/bin/bash
> debug.log
> summary.log
start_time_tc
gre=$($INTERMAIL/lib/immgrserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "########## gre=$gre" >>$debuglog
if [ $gre == "1" ]
then
		prints "Verions of the greserver is : $msg_msg_ver2 $msg_msg_ver3  " "Veriosn_of_mgrserver" "2"
		Result="0"
else				
		prints "ERROR: We are not able to find MX version" "Veriosn_of_mgrserver" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_mgrserver" "1"
		Result="1"
fi
summary "Version_of_mgrserver" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog