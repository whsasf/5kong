#!/bin/bash

>$INTERMAIL/log/imapserv.trace
echo "================================================================"
echo "PERFORMING IMAP-FETCH and IMAP-EXAMINE OPERATIONS concurrently.."
echo "================================================================"
$PATH_TO_SCRIPTS/Command_Scripts/examine.sh &
$PATH_TO_SCRIPTS/Command_Scripts/fetch.sh &
sleep 2
$PATH_TO_SCRIPTS/TC_2_1_65/IC_TC_validation.sh
echo "============================="
echo
