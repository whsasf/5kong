#!/bin/bash


#deliever 5 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 6   UTF8_body_equals_80_CTE_7bit.txt
imap_uid_fetch "$Sanityuser" "1001,1003,1005" "firstline"     
firstlinedata_count=`grep "qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 3 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_UTF8_body_equals_80_CTE_7bit_uid_multiple test successfully!"  "IMAP:Body_preview_UTF8_body_equals_80_CTE_7bit_uid_multiple"  2
	Result=0
else
  prints "IMAP:Body_preview_UTF8_body_equals_80_CTE_7bit_uid_multiple test failed!"  "IMAP:Body_preview_UTF8_body_equals_80_CTE_7bit_uid_multiple"  1
  Result=1
fi
summary "IMAP:Body_preview_UTF8_body_equals_80_CTE_7bit_uid_multiple" $Result
