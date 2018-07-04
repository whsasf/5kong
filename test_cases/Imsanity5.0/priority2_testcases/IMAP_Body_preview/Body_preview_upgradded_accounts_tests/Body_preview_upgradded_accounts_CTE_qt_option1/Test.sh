#!/bin/bash


#deliever 4 messages  ro mailbox
$smpl    -u  $Sanityuser@${default_domain} -c 4   UTF8_body_more_than_80_CTE_qt.txt
imap_fetch "$Sanityuser" "1:2,3:3" "firstline"     
firstlinebaddata_count=`grep -i "BAD Invalid attribute list in FETCH"   imapfetch.tmp |wc -l`
echo "########## firstlinebaddata_count=$firstlinebaddata_count" >>debug.log
if [ $firstlinebaddata_count -eq 1 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_option1 faild without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_option1_without_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_option1 not work properly without enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_option1_without_key"  1		
fi

#enable key
set_config_keys "/*/common/enableXFIRSTLINE" "true"
imap_fetch "$Sanityuser" "1:2,3:3" "firstline"     
firstlinedata_count=`grep -i "FIRSTLINE (\"\")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
if [ $firstlinedata_count -eq 3 ];then
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_option1 success after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_option1_with_key"  2		
else
		prints "IMAP:Body_preview_upgradded_account_CTE_qt_option1 failed after enabling key!"  "IMAP:Body_preview_upgradded_account_CTE_qt_option1_with_key"  1		
fi

#imboxmaint
Result=1
echo "...running imboxmaint ..."
echo "...running imboxmaint ..." >>debug.log
imboxmaint_fn $Sanityuser@${default_domain}
imap_fetch "$Sanityuser" "1:2,3:3" "firstline" 
firstlinedata_count=`grep "qwe wwqe، ويمكن تح No boweq dy! いくつにな  我们是中国人，xx\")"   imapfetch.tmp |wc -l`
echo "########## firstlinedata_count=$firstlinedata_count"  >>debug.log
echo "########## Result=$Result"  >>debug.log
if [ $firstlinedata_count -eq 3 -a $Result -eq 0 ];then
	prints "IMAP:Body_preview_upgradded_account_CTE_qt_option1 test successfully!"  "IMAP:Body_preview_upgradded_account_CTE_qt_option1"  2
	Result=0
else
  prints "IMAP:Body_preview_upgradded_account_CTE_qt_option1 test failed!"  "IMAP:Body_preview_upgradded_account_CTE_qt_option1"  1
  Result=1
fi
summary "IMAP:Body_preview_upgradded_account_CTE_qt_option1" $Result
