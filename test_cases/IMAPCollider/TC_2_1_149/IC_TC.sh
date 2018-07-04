#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-copy and IMAP-close OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/copy.sh &
$PATH_TO_SCRIPTS/Command_Scripts/close.sh &
$PATH_TO_SCRIPTS/Command_Scripts/copy.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_149/IC_TC_validation.sh
echo "============================="
echo
