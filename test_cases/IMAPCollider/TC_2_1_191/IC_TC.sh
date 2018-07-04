#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-uidsearch and IMAP-uidstore OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/uidsearch.sh &
$PATH_TO_SCRIPTS/Command_Scripts/uidstore.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_191/IC_TC_validation.sh
echo "============================="
echo
