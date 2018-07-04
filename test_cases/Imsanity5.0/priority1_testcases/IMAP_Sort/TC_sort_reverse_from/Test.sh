#!/bin/bash

imap_sort "$Sanityuser" "INBOX" "reverse from"
verify_imapsort=$(cat imapsort.tmp | grep -i "SORT" | grep -i "1005 1003 1006 1007 1002 1001 1008 1004" | wc -l)
verify_imapsort=`echo $verify_imapsort | tr -d " "`
echo "########## verify_imapsort=$verify_imapsort" >>debug.log

if [ "$verify_imapsort" == "1" -a "$Result" == "0" ]
then
	prints "IMAP SORT for $imapUser is successful" "TC_sort_reverse_from" "2"
	Result="0"
else
	prints "-ERR IMAP SORT for $imapUser is unsuccessful" "TC_sort_reverse_from" "1"
	Result="1"
fi
summary "IMAP:TC_sort_reverse_from" $Result
	