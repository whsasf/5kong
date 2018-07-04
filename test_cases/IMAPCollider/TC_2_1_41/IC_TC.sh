#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "======================================================================"
echo "PERFORMING IMAP-FETCH RFC822 and IMAP-APPEND OPERATIONS concurrently.."
echo "======================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/fetch.sh &
$PATH_TO_SCRIPTS/Command_Scripts/append.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_41/IC_TC_validation.sh
#cat $INTERMAIL/log/imapserv.trace | egrep -i "C\[|S\[" |egrep -v "server" | cut -d "[" -f 2-9 | egrep -vi "login|logout" > test_TC_logs41.txt
#cat test_TC_logs41.txt
echo "============================="
echo
