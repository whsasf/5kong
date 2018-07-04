#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-copy and IMAP-select OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/copy.sh &
$PATH_TO_SCRIPTS/Command_Scripts/select.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_33/IC_TC_validation.sh
echo "============================="
echo
