#!/bin/bash

shareFolder "$mxoshost_port" "$Sanityuser1" "$Sanityuser2"  "Trash"
#imctrl  allhosts  killStart mss   &> restart.txt
sleep 5
imap_fetch "$Sanityuser2" "1" "rfc822" "$Sanityuser1-Trash"
#cat imapfetch.txt  >me
target=`grep -i "xcvbnjhyt" imapfetch.tmp |wc -l`
echo "########## Result_share=$Result_share" >>debug.log
echo "########## target=$target" >>debug.log
if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
	Result=0
	prints "Foldershare for system folder:$foldername from $userfrom to $userto is successful" "TC_shareFolder_system" "2"
else
	Result=1
	prints "-ERR Foldershare for system folder:$foldername from $userfrom to $userto is unsuccessful" "TC_shareFolder_system" "1"
fi
summary "Sharefolder:TC_shareFolder_system" $Result
	
