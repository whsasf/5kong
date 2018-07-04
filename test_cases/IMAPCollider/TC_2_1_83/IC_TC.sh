#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-store and IMAP-rename OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/store.sh &
$PATH_TO_SCRIPTS/Command_Scripts/rename.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_83/IC_TC_validation.sh
echo "============================="
echo
