#!/bin/bash

imap_sort "$Sanityuser" "INBOX" "displayfrom"

verify_imapsort=$(cat imapsort.tmp | grep -i "SORT" | grep -i "1004 1008 1002 1007 1006 1003 1005 1001" | wc -l)
verify_imapsort=`echo $verify_imapsort | tr -d " "`
echo "########## verify_imapsort=$verify_imapsort" >>debug.log

if [ "$verify_imapsort" == "1" -a "$Result" == "0" ]
then
	prints "IMAP SORT for $imapUser is successful" "TC_sort_displayfrom" "2"
	Result="0"
else
	prints "-ERR IMAP SORT for $imapUser is unsuccessful" "TC_sort_displayfrom" "1"
	Result="1"
fi
summary "IMAP:TC_sort_displayfrom" $Result
	