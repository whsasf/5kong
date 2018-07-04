#!/bin/bash


#deliever 5 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 6   UTF8_body_less_than_80_CTE_qt.txt
imap_fetch "$Sanityuser" "1,3,5" "firstline"     
firstlinedata_count=`grep "، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 3 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_UTF8_body_less_than_80_CTE_qt_multiple test successfully!"  "IMAP:Body_preview_UTF8_body_less_than_80_CTE_qt_multiple"  2
	Result=0
else
  prints "IMAP:Body_preview_UTF8_body_less_than_80_CTE_qt_multiple test failed!"  "IMAP:Body_preview_UTF8_body_less_than_80_CTE_qt_multiple"  1
  Result=1
fi
summary "IMAP:Body_preview_UTF8_body_less_than_80_CTE_qt_multiple" $Result
