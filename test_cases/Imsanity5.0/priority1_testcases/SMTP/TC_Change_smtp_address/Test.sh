#!/bin/bash

imboxstats_fn "$Sanityuser" 
msg_exists=$(cat log_imboxstats.tmp | grep -i "Total Messages Stored" | cut -d ":" -f2)
msg_exists=`echo $msg_exists | tr -d " "`

imdbcontrol ModifyAccountSmtp $Sanityuser ${default_domain} testuser ${default_domain}
mail_send "testuser" "small" "2"	"$Sanityuser"		

imboxstats_fn "testuser" 
msg_exists_new=$(cat log_imboxstats.tmp | grep -i "Total Messages Stored" | cut -d ":" -f2)
msg_exists_new=`echo $msg_exists_new | tr -d " "`
total_count=$(($msg_exists+2))
echo "########## msg_exists_new=$msg_exists_new" >>debug.log
echo "########## total_count=$total_count" >>debug.log

if [ "$msg_exists_new" == "$total_count" ]
then
	prints "Change of SMTP address is working fine" "change_smtp_add" "2"
	Result="0"
else
	prints "ERROR:Change of SMTP address is not working fine. Please check manually." "change_smtp_add" "1"
	Result="1"
fi
		
summary "SMTP:Change_of_SMTP_address" $Result