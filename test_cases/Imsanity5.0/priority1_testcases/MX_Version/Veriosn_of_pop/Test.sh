#!/bin/bash
> debug.log
> summary.log
start_time_tc
pop=$($INTERMAIL/lib/popserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "########## pop=$pop" >> $debuglog
if [ $pop == "1" ]
then
		prints "Verions of the pop : $msg_msg_ver2 $msg_msg_ver3 " "Veriosn_of_pop" "2"
		Result="0" 
else	
		prints "ERROR: We are not able to find pop version" "Veriosn_of_pop" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_pop" "1"
		Result="1"
fi
summary "Version_of_pop" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog