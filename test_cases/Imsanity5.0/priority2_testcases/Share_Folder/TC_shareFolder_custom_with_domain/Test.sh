#!/bin/bash

shareFolder "$mxoshost_port" "$Sanityuser1" "$Sanityuser2"  "New_folder"
#imctrl  allhosts  killStart mss   &> restart.txt
sleep 5
imap_fetch "$Sanityuser2" "1" "rfc822" "$Sanityuser1@${default_domain}-New_folder"
#cat imapfetch.txt  >me4
target=`grep -i "ccvbnjhyt" imapfetch.tmp |wc -l`
echo "########## Result_share=$Result_share" >>debug.log
echo "########## target=$target" >>debug.log
if [ $Result_share -eq 0 -a $Result -eq 0 -a $target -eq 1 ];then
		prints "Foldershare with domian for customer folder:$foldername from $userfrom to $userto is successful" "TC_shareFolder_custom_with_domain" "2"
		Result=0
else
		prints "-ERR Foldershare with domain for customer folder:$foldername from $userfrom to $userto is unsuccessful" "TC_shareFolder_custom_with_domain" "1"
		Result=1
fi
summary "Sharefolder:TC_shareFolder_custom_with_domain" $Result

	
