#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-store and IMAP-examine OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/store.sh &
$PATH_TO_SCRIPTS/Command_Scripts/examine.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_81/IC_TC_validation.sh
echo "============================="
echo
