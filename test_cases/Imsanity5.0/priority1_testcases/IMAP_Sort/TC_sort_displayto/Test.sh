#!/bin/bash

imap_sort "$Sanityuser" "INBOX" "displayto"
	#verify_imapsort=$(cat imapsort.txt | grep -i "SORT" | grep -i "1005 1003 1004" | wc -l)
verify_imapsort=$(cat imapsort.tmp | grep -i "SORT" | grep -i "1001 1003 1007 1008 1004 1006 1002 1005" | wc -l)
verify_imapsort=`echo $verify_imapsort | tr -d " "`
echo "########## verify_imapsort=$verify_imapsort"  >>debug.log

if [ "$verify_imapsort" == "1"  -a "$Result" == "0" ]
then
	prints "IMAP SORT for $imapUser is successful" "TC_sort_displayto" "2"
	Result="0"
else
	prints "-ERR IMAP SORT for $imapUser is unsuccessful" "TC_sort_displayto" "1"
	Result="1"
fi
summary "IMAP:TC_sort_displayto" $Result
	