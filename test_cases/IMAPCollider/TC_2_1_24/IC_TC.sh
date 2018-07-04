#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-store and IMAP-select OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/store.sh &
$PATH_TO_SCRIPTS/Command_Scripts/select.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_24/IC_TC_validation.sh
echo "============================="
echo
