#!/bin/bash
> debug.log
> summary.log
start_time_tc
imap=$($INTERMAIL/lib/imapserv -version | tr -d " "| grep "$msg_msg_ver2" | wc -l)
echo "########## imap=$imap"  >>$debuglog
if [ $imap == "1" ]
then
		prints "Verions of the imap : $msg_msg_ver2 $msg_msg_ver3  " "Veriosn_of_imap" "2"
		Result="0"
else	
		prints "ERROR: We are not able to find imap version" "Veriosn_of_imap" "1"
		prints "ERROR: Please check Manually" "Veriosn_of_imap" "1"
		Result="1"
fi
summary "Version_of_imap" $Result
cat debug.log   >> $debuglog
cat summary.log >> $summarylog