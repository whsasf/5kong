#!/bin/bash


#deliever 6 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 6   UTF8_body_more_than_80_CTE_base64.txt
imap_fetch "$Sanityuser" "1,3,5" "firstline"     
firstlinebaddata_count=`grep -i "BAD Invalid attribute list in FETCH"   imapfetch.tmp |wc -l`
echo "########## firstlinebaddata_count=$firstlinebaddata_count" >>debug.log
if [ $firstlinebaddata_count -eq 1 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_multiple faild without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_multiple_without_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_multiple not work properly without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_multiple_without_key"  1		
fi

#enable key
set_config_keys "/*/common/enableXFIRSTLINE" "true"
imap_fetch "$Sanityuser" "1,3,5" "firstline"     
firstlinedata_count=`grep -i "FIRSTLINE (\"\")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
if [ $firstlinedata_count -eq 3 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_multiple success after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_multiple_with_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_multiple failed after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_multiple_with_key"  1		
fi

#imboxmaint
Result=1
echo "...running imboxmaint ..."
echo "...running imboxmaint ..." >>debug.log
imboxmaint_fn $Sanityuser@${default_domain}
imap_fetch "$Sanityuser" "1,3,5" "firstline" 
firstlinedata_count=`grep "qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 3 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_upgradded_account_CTE_base64_multiple test successfully!"  "IMAP:Body_preview_upgradded_account_CTE_base64_multiple"  2
	Result=0
else
  prints "IMAP:Body_preview_upgradded_account_CTE_base64_multiple test failed!"  "IMAP:Body_preview_upgradded_account_CTE_base64_multiple"  1
  Result=1
fi
summary "IMAP:Body_preview_upgradded_account_CTE_base64_multiple" $Result
