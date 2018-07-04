#!/bin/bash

echo
echo "#############################"
echo "      Starting CLEANUP       "
echo "#############################"

echo "Re-Setting traceOutput Config key to ''"
imconfcontrol -install -key "/*/common/traceOutputLevel"="" > config_changes_cleanup.txt
echo "Config changes reverted Successfully."
#echo
echo "Resetting IMAP TRACE Logs"
>$INTERMAIL/log/imapserv.trace
echo "Imap Traces resetted Successfully."
#echo
echo "Deleting temporary files.."
rm -rf temp.txt config_changes_cleanup.txt config_changes.txt
echo "Temporary Files removed."
echo "delete account"
account-delete concuser$id@openwave.com
#echo
echo "Cleanup Completed."
echo "============================="
