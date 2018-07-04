#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-SELECT and IMAP-APPEND OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/select.sh &
$PATH_TO_SCRIPTS/Command_Scripts/append.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_22/IC_TC_validation.sh
echo "============================="
echo
