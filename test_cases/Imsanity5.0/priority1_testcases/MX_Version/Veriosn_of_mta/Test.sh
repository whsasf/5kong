#!/bin/bash
> debug.log
> summary.log
start_time_tc
mta=$($INTERMAIL/lib/mta -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "########## mta=$mta" >>$debuglog
if [ $mta == "1" ]
then
		prints "Verions of the mta : $msg_msg_ver2 $msg_msg_ver3 " "Veriosn_of_mta" "2"
		Result="0"
else
				 
		prints "ERROR: We are not able to find mta version" "Veriosn_of_mta" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_mta" "1"
		Result="1"
fi
summary "Version_of_mta" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog