#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc

#enable condstore
echo "enable condstore............."
set_config_keys "/*/common/enableCONDSTORE" "true"  "1"
sleep 3
	
#creaet account
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi


#clear current imilbox in $Sanityuser1@${default_domain} 
immsgdelete  $Sanityuser@${default_domain}  -all 

#deliever 3 messages to $Sanityuser11@${default_domain}
$smpl  -u $Sanityuser@${default_domain}   -c 3  $message_template_1K