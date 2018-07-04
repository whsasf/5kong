#!/bin/bash


#deliever 2 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 2   Body_preview_symbols_less_than_80-qt.txt
imap_fetch "$Sanityuser" "1:*" "firstline"     
firstlinedata_count=`grep "\"\"\!\@\#\$%\^&\*()_+-=\[]{};',\./:\"?><《》『』【】；。“”：：~～\@\#￥&\*\" \""   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_symbols_less_than_80-qt test successfully!"  "IMAP:Body_preview_symbols_less_than_80-qt"  2
	Result=0
else
  prints "IMAP:Body_preview_symbols_less_than_80-qt test failed!"  "IMAP:Body_preview_symbols_less_than_80-qt"  1
  Result=1
fi
summary "IMAP:Body_preview_symbols_less_than_80-qt" $Result
