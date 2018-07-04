#!/bin/bash


#deliever 2 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 3   UTF8_body_less_than_80_CTE_base64.txt
imap_fetch "$Sanityuser" "1:2" "firstline"     
firstlinedata_count=`grep "، ويمكن تح No body! いくつにな  我们是中国人， \")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_UTF8_body_less_than_80_CTE_base64_range test successfully!"  "IMAP:Body_preview_UTF8_body_less_than_80_CTE_base64_range"  2
	Result=0
else
  prints "IMAP:Body_preview_UTF8_body_less_than_80_CTE_base64_range test failed!"  "IMAP:Body_preview_UTF8_body_less_than_80_CTE_base64_range"  1
  Result=1
fi
summary "IMAP:Body_preview_UTF8_body_less_than_80_CTE_base64_range" $Result
