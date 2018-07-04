#!/bin/bash


#deliever 2 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 2   UTF8_body_more_than_80_CTE_base64.txt
imap_uid_fetch "$Sanityuser" "1001:1002" "firstline"     
firstlinebaddata_count=`grep -i "BAD Invalid attribute list in UID FETCH"   imapuidfetch.tmp |wc -l`
echo "########## firstlinebaddata_count=$firstlinebaddata_count" >>debug.log
if [ $firstlinebaddata_count -eq 1 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range faild without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range_without_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range not work properly without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range_without_key"  1		
fi

#enable key
set_config_keys "/*/common/enableXFIRSTLINE" "true"
imap_uid_fetch "$Sanityuser" "1001:1002" "firstline"     
firstlinedata_count=`grep -i "FIRSTLINE (\"\")"   imapuidfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
if [ $firstlinedata_count -eq 2 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range success after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range__with_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range failed after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range_with_key"  1		
fi

#imboxmaint
Result=1
echo "...running imboxmaint ..."
echo "...running imboxmaint ..." >>debug.log
imboxmaint_fn $Sanityuser@${default_domain}
imap_uid_fetch "$Sanityuser" "1001:1002" "firstline" 
firstlinedata_count=`grep "qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range test successfully!"  "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range"  2
	Result=0
else
  prints "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range test failed!"  "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range"  1
  Result=1
fi
summary "IMAP:Body_preview_upgradded_account_CTE_base64_uid_range" $Result
