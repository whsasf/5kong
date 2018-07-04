#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "======================================================================"
echo "PERFORMING IMAP FETCH RFC822 and IMAP-SELECT OPERATIONS concurrently.."
echo "======================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/select.sh &
$PATH_TO_SCRIPTS/Command_Scripts/fetch.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_23/IC_TC_validation.sh
echo "============================="
echo
