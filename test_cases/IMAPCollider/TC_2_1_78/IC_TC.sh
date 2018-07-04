#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-search and IMAP-store OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/store.sh &
$PATH_TO_SCRIPTS/Command_Scripts/search.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_78/IC_TC_validation.sh
echo "============================="
echo
