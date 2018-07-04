#!/bin/bash
start_time_tc
dir=$($INTERMAIL/lib/imdirserv -version | grep "$dir1" | wc -l)
echo "########## dir=$dir"  >> $debuglog
if [ $dir == "1" ]
then
		prints "Verions of the dirserver is :$dir1 " "Veriosn_of_dirserver" "2"
		Result="0"
else									
		prints "ERROR: We are not able to find dirserver version" "Veriosn_of_dirserver" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_dirserver" "1"
		Result="1"
fi
summary "Version_of_dirserver" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog