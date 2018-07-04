#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc


set_config_keys "/*/common/mailFolderQuotaEnabled" "true" "1"
set_config_keys "/*/mxos/ldapCosCachingEnabled" "false" "0"
maint_cn=$(cat $INTERMAIL/config/config.db | grep clusterName|grep -v imboxmaint | cut -d "/" -f2 | cut -d "-" -f2) 
set_config_keys "/*/imboxmaint/clusterName" "$maint_cn" 
#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn "$Sanityuser"

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

immsgdelete $Sanityuser@${default_domain} -all 
imcheckfq_utility "$Sanityuser"
#deleve 1 message
$smpl  -u $Sanityuser@${default_domain}    $message_template_1K	
quotaset_check="0"
quotaset_check=$(cat log_imcheckfq.tmp | egrep -i "AgeSeconds" | wc -l)
quotaset_check=`echo $quotaset_check | tr -d " "`
echo "########## quotaset_check=$quotaset_check"  >>debug.log
sleep 1
