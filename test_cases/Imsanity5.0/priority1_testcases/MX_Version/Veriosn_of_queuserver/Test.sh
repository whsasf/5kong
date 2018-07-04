#!/bin/bash
> debug.log
> summary.log
start_time_tc
queu=$($INTERMAIL/lib/imqueueserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "########## queu=$queu"  >>$debuglog
if [ $queu == "1" ]
then
		prints "Verions of the queu server is : $msg_msg_ver2 $msg_msg_ver3  " "Veriosn_of_queuserver" "2"
		Result="0"
else					
		prints "ERROR: We are not able to find queue server version" "Veriosn_of_queuserver" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_queuserver" "1"
		Result="1"
fi
summary "Version_of_queuserver" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog