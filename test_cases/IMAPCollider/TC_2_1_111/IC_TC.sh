#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-create and IMAP-LIST OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/list.sh &
$PATH_TO_SCRIPTS/Command_Scripts/list.sh &
$PATH_TO_SCRIPTS/Command_Scripts/create.sh &
$PATH_TO_SCRIPTS/Command_Scripts/list.sh &
$PATH_TO_SCRIPTS/Command_Scripts/list.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_111/IC_TC_validation.sh
echo "============================="
echo
