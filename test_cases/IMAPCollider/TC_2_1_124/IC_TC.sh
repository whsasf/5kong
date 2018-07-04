#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-search and IMAP-list OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/search.sh &
$PATH_TO_SCRIPTS/Command_Scripts/list.sh &
$PATH_TO_SCRIPTS/Command_Scripts/search.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_124/IC_TC_validation.sh
echo "============================="
echo
