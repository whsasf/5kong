#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-search and IMAP-select OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/search.sh &
$PATH_TO_SCRIPTS/Command_Scripts/select.sh &
$PATH_TO_SCRIPTS/Command_Scripts/search.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_27/IC_TC_validation.sh
echo "============================="
echo
