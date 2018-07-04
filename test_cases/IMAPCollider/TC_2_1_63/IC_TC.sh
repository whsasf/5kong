#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-DELETE and IMAP-FETCH OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/delete.sh &
$PATH_TO_SCRIPTS/Command_Scripts/fetch.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_63/IC_TC_validation.sh
echo "============================="
echo
