#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-store and IMAP-fetch OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/store.sh &
$PATH_TO_SCRIPTS/Command_Scripts/fetch.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_59/IC_TC_validation.sh
echo "============================="
echo
