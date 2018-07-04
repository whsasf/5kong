#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-copy and IMAP-status OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/copy.sh &
$PATH_TO_SCRIPTS/Command_Scripts/status.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_189/IC_TC_validation.sh
echo "============================="
echo
