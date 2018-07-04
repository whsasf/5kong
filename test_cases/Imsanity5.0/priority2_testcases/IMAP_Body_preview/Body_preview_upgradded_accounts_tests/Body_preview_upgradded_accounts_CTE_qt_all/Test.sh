#!/bin/bash


#deliever 2 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 2   UTF8_body_more_than_80_CTE_qt.txt
imap_fetch "$Sanityuser" "1:*" "firstline"     
firstlinebaddata_count=`grep -i "BAD Invalid attribute list in FETCH"   imapfetch.tmp |wc -l`
echo "########## firstlinebaddata_count=$firstlinebaddata_count" >>debug.log
if [ $firstlinebaddata_count -eq 1 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_all faild without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_all_without_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_all not work properly without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_all_without_key"  1		
fi

#enable key
set_config_keys "/*/common/enableXFIRSTLINE" "true"
imap_fetch "$Sanityuser" "1:*" "firstline"     
firstlinedata_count=`grep -i "FIRSTLINE (\"\")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
if [ $firstlinedata_count -eq 2 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_all success after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_all_with_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_all failed after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_all_with_key"  1		
fi

#imboxmaint
Result=1
echo "...running imboxmaint ..."
echo "...running imboxmaint ..." >>debug.log
imboxmaint_fn $Sanityuser@${default_domain}
imap_fetch "$Sanityuser" "1:*" "firstline" 
firstlinedata_count=`grep "qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 2 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_upgradded_account_CTE_qt_all test successfully!"  "IMAP:Body_preview_upgradded_account_CTE_qt_all"  2
	Result=0
else
  prints "IMAP:Body_preview_upgradded_account_CTE_qt_all test failed!"  "IMAP:Body_preview_upgradded_account_CTE_qt_all"  1
  Result=1
fi
summary "IMAP:Body_preview_upgradded_account_CTE_qt_all" $Result
