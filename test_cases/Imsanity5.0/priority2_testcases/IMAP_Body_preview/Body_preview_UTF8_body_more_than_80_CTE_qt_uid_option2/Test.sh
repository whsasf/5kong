#!/bin/bash


#deliever 4 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 4   UTF8_body_more_than_80_CTE_qt.txt
imap_uid_fetch "$Sanityuser" "1001:1002,1003" "firstline"     
firstlinedata_count=`grep "qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 3 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_UTF8_body_more_than_80_CTE_qt_uid_option2 test successfully!"  "IMAP:Body_preview_UTF8_body_more_than_80_CTE_qt_uid_option2"  2
	Result=0
else
  prints "IMAP:Body_preview_UTF8_body_more_than_80_CTE_qt_uid_option2 test failed!"  "IMAP:Body_preview_UTF8_body_more_than_80_CTE_qt_uid_option2"  1
  Result=1
fi
summary "IMAP:Body_preview_UTF8_body_more_than_80_CTE_qt_uid_option2" $Result
