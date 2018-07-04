#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-DELETE and IMAP-SELECT OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/delete.sh &
$PATH_TO_SCRIPTS/Command_Scripts/select.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_28/IC_TC_validation.sh
echo "============================="
echo
