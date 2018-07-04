#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-store and IMAP-append OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/store.sh &
$PATH_TO_SCRIPTS/Command_Scripts/append.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_42/IC_TC_validation.sh
echo "============================="
echo
