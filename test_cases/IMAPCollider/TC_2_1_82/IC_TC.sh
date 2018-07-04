#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-store and IMAP-list OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/store.sh &
$PATH_TO_SCRIPTS/Command_Scripts/list.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_82/IC_TC_validation.sh
echo "============================="
echo
