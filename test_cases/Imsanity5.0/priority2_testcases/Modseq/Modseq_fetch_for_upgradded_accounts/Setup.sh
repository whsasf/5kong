#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc
#add imboxmaint related key :
maint_cn=$(cat $INTERMAIL/config/config.db | grep clusterName|grep -v imboxmaint | cut -d "/" -f2 | cut -d "-" -f2) 
set_config_keys "/*/imboxmaint/clusterName" "$maint_cn"
	
	
#creaet account
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser


imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi


#clear current imilbox in test1@${default_domain} 
immsgdelete  $Sanityuser@${default_domain}  -all 


