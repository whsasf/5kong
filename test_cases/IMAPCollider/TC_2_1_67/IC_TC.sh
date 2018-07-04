#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-fetch and IMAP-rename OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/fetch.sh &
$PATH_TO_SCRIPTS/Command_Scripts/rename.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_67/IC_TC_validation.sh
echo "============================="
echo
