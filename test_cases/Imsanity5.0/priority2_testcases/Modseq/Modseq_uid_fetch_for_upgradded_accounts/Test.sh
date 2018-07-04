#!/bin/bash
#deliever  2 messages to $Sanityuser
$smpl  -u $Sanityuser@${default_domain}   -c 2  $message_template_1K
#enable modseq
echo "enable condstore............."
set_config_keys "/*/common/enableCONDSTORE" "true"  "1"
sleep 3
#imapfetch
imap_uid_fetch "$Sanityuser" "1:*" "modseq"
echo "========== the content of imapuidfetch.tmp=========="
cat imapuidfetch.tmp
echo "===================================================="
mm1=`grep MODSEQ  imapuidfetch.tmp |head -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
mm2=`grep MODSEQ  imapuidfetch.tmp |tail -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
#mm1 and mm2 should eauals 0
let mm3=mm1+mm2

#run imboxmaint
imboxmaint_fn   $Sanityuser@${default_domain} 
sleep 3
#fetch modseq again
imap_uid_fetch "$Sanityuser" "1:*" "modseq" 
echo "========== the content of imapuidfetch.tmp=========="  
cat imapuidfetch.tmp
echo "===================================================="
mm5=`grep MODSEQ  imapuidfetch.tmp |head -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
mm6=`grep MODSEQ  imapuidfetch.tmp |tail -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
echo "########## mm3=$mm3" >>debug.log
echo "########## mm1=$mm1" >>debug.log
echo "########## mm2=$mm2" >>debug.log
echo "########## mm5=$mm5" >>debug.log
echo "########## mm6=$mm6" >>debug.log
echo "########## Result=$Result" >>debug.log
if [ $mm3 -eq 0 -a $mm5 -ge 1000 -a $mm6 -ge 1000 -a $Result -eq 0 ];then
  prints "IMAP:TC_uid_fetch_modseq_for_upgradded_accounts test successfully!"  "TC_uid_fetch_modseq_for_upgradded_accounts"  2
	Result=0
else
  prints "IMAP:TC_uid_fetch_modseq_for_upgradded_accounts test failed!"  "IMAP:TC_uid_fetch_modseq_for_upgradded_accounts"  1
	Result=1
fi
summary "IMAP:TC_uid_fetch_modseq_for_upgradded_accounts" $Result
