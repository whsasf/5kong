#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc


#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

immsgdelete $Sanityuser@${default_domain} -all 
sleep 15
imdbcontrol sac $Sanityuser ${default_domain} mailquotamaxmsgkb 0
imdbcontrol sac $Sanityuser ${default_domain} mailquotatotkb 0



mail_send "$Sanityuser" "small" "1"
mail1=$Result
mail_send "$Sanityuser" "large" "1"
mail2=$Result


