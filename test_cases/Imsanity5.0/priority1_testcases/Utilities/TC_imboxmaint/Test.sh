#!/bin/bash
if [ "$quotaset_check" == "1" ]
then
		imboxstats_fn "$Sanityuser"
		msg_exists=$(cat log_imboxstats.tmp | grep -i "Total Messages Stored" | cut -d ":" -f2)
		msg_exists=`echo $msg_exists | tr -d " "`	
		
		prints  "Now Running Maintenance on this mailbox, please wait..." "TC_imboxmaint"
		imboxmaint_fn $Sanityuser@${default_domain} 
		
		check_maint=$(cat imboxmaints.tmp | grep -i "maintenance done for mailbox" | wc -l)
		check_maint=`echo $check_maint | tr -d " "`	
		
		imboxstats_fn "$Sanityuser"
		msg_exists_new=$(cat log_imboxstats.tmp | grep -i "Total Messages Stored" | cut -d ":" -f2)
		msg_exists_new=`echo $msg_exists_new | tr -d " "`
		prints  "After running maintenance, there are "$msg_exists_new" Messages in the mailbox" "TC_imboxmaint"
		echo "########## msg_exists_new=$msg_exists_new" >>debug.log
		echo "########## check_maint=$check_maint"  >>debug.log
		if [[ "$msg_exists_new" == "0" && "$check_maint" == "1" ]]
		then
			prints  "imboxmaint utility for $Sanityuser is working fine." "TC_imboxmaint" "2"
			Result="0"	
		else
			prints  "ERROR: imboxmaint utility for $Sanityuser is not working fine. Please check Manually." "TC_imboxmaint" "1"
			Result="1"
		fi
	else
		prints  "ERROR: FolderQuota is not set properly for $Sanityuser." "TC_imboxmaint" "1"
	fi
	
summary "UTILITIES:TC_imboxmaint" $Result	