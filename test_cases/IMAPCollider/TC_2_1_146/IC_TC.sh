#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-EXAMINE and IMAP-CLOSE OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/close.sh &
$PATH_TO_SCRIPTS/Command_Scripts/examine.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_146/IC_TC_validation.sh
echo "============================="
echo
