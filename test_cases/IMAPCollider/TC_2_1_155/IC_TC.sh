#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-close and IMAP-status OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/status.sh &
$PATH_TO_SCRIPTS/Command_Scripts/close.sh &
$PATH_TO_SCRIPTS/Command_Scripts/status.sh &
$PATH_TO_SCRIPTS/Command_Scripts/status.sh &
$PATH_TO_SCRIPTS/Command_Scripts/status.sh &
$PATH_TO_SCRIPTS/Command_Scripts/status.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_155/IC_TC_validation.sh
echo "============================="
echo
