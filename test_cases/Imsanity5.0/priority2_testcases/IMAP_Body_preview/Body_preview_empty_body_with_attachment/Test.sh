#!/bin/bash


#deliever 2 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 2   empty_body_with_attachment.txt
imap_fetch "$Sanityuser" "1:*" "firstline"     
firstlinedata_count=`grep "FETCH (FIRSTLINE (\"\")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_empty_body_with_attachment test successfully!"  "IMAP:Body_preview_empty_body_with_attachment"  2
	Result=0
else
	prints "IMAP:Body_preview_empty_body_with_attachment test failed!"  "IMAP:Body_preview_empty_body_with_attachment"  1
  Result=1
fi
summary "IMAP:Body_preview_empty_body_with_attachment" $Result
