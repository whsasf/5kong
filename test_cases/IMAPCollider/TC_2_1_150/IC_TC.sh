#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-close and IMAP-uidstore OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/close.sh &
$PATH_TO_SCRIPTS/Command_Scripts/uidstore.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_150/IC_TC_validation.sh
echo "============================="
echo
