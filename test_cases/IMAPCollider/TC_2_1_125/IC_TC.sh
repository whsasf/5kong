#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-search and IMAP-rename OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/search.sh &
$PATH_TO_SCRIPTS/Command_Scripts/rename.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_125/IC_TC_validation.sh
echo "============================="
echo
