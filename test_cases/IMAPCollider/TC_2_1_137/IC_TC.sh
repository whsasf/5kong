#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-delete and IMAP-rename OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/delete.sh &
$PATH_TO_SCRIPTS/Command_Scripts/rename.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_137/IC_TC_validation.sh
echo "============================="
echo
