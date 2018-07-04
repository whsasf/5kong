#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-SELECT and IMAP-CLOSE OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/close.sh &
$PATH_TO_SCRIPTS/Command_Scripts/select.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_29/IC_TC_validation.sh
echo "============================="
echo
