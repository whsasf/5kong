#!/bin/bash


#deliever 6 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 6   UTF8_body_more_than_80_CTE_7bit.txt
imap_uid_fetch "$Sanityuser" "1001,1003,1005" "firstline"     
firstlinebaddata_count=`grep -i "BAD Invalid attribute list in UID FETCH"   imapuidfetch.tmp |wc -l`
echo "########## firstlinebaddata_count=$firstlinebaddata_count" >>debug.log
if [ $firstlinebaddata_count -eq 1 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple faild without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple_without_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple not work properly without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple_without_key"  1		
fi

#enable key
set_config_keys "/*/common/enableXFIRSTLINE" "true"
imap_uid_fetch "$Sanityuser" "1001,1003,1005" "firstline"     
firstlinedata_count=`grep -i "FIRSTLINE (\"\")"   imapuidfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
if [ $firstlinedata_count -eq 3 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple success after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple__with_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple failed after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple_with_key"  1		
fi

#imboxmaint
Result=1
echo "...running imboxmaint ..."
echo "...running imboxmaint ..." >>debug.log
imboxmaint_fn $Sanityuser@${default_domain}
imap_uid_fetch "$Sanityuser" "1001,1003,1005" "firstline" 
firstlinedata_count=`grep "qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapuidfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 3 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple test successfully!"  "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple"  2
	Result=0
else
  prints "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple test failed!"  "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple"  1
  Result=1
fi
summary "IMAP:Body_preview_upgradded_account_CTE_7bit_uid_multiple" $Result
