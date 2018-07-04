#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-CREATE and IMAP-DELETE OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/create.sh &
$PATH_TO_SCRIPTS/Command_Scripts/delete.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_108/IC_TC_validation.sh
echo "============================="
echo
