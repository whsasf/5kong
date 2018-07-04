#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-examine and IMAP-uidfetch OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/examine.sh &
$PATH_TO_SCRIPTS/Command_Scripts/uidfetch.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_162/IC_TC_validation.sh
echo "============================="
echo
