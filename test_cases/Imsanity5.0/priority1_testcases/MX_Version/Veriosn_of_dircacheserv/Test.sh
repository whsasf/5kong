#!/bin/bash
start_time_tc
dircache=$($INTERMAIL/lib/imdircacheserv -version | grep "$dircache1" | wc -l)
echo "########## dircache=$dircache" >> $debuglog
if [ $dircache == "1" ]
then
		prints "Verions of the dircacheserv is :$dircache1 " "Veriosn_of_dircacheserv" "2"
		Result="0"
else
		prints "ERROR: We are not able to find dircacheserv version" "Veriosn_of_dircacheserv" "1"
		prints "ERROR: Please check Manually." "Veriosn_of_dircacheserv" "1"
		Result="1"
fi
summary "Version_of_dircacheserv" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog