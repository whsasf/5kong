#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-list and IMAP-uidsearch OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/uidsearch.sh &
$PATH_TO_SCRIPTS/Command_Scripts/uidsearch.sh &
$PATH_TO_SCRIPTS/Command_Scripts/list.sh &
$PATH_TO_SCRIPTS/Command_Scripts/uidsearch.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_170/IC_TC_validation.sh
echo "============================="
echo
