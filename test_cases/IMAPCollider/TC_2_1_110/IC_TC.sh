#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-CREATE and IMAP-EXAMINE OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/examine.sh &
$PATH_TO_SCRIPTS/Command_Scripts/create.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_110/IC_TC_validation.sh
echo "============================="
echo
