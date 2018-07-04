#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc

#set keys    
set_config_keys "/*/imapserv/enableTHREAD" "true" 1 	
set_config_keys "/*/mss/ConversationViewEnabled" "true" 1 

#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi

immsgdelete $Sanityuser@${default_domain} -all 


folder="Folder1/Folder2"
echo "folder=$folder"  >>debug.log

#create nested folder
#imap_create "$Sanityuser" "Folder1/Folder2"
#thread message deliever
mail_send_thread $Sanityuser "REFERENCES" $folder
mail1=$Result
echo "mail1=$mail1"  >>debug.log
mail_send_thread $Sanityuser "REFERENCES" $folder
mail2=$Result
echo "mail2=$mail2"  >>debug.log
mail_send_thread $Sanityuser "REFERENCES" $folder 1
mail3=$Result
echo "mail3=$mail3"  >>debug.log
mail_send_thread $Sanityuser "REFERENCES" $folder 2
mail4=$Result
echo "mail4=$mail4"  >>debug.log
mail_send_thread $Sanityuser "REFERENCES" $folder 4
mail5=$Result
echo "mail5=$mail5"  >>debug.log
result=($mail1 $mail2 $mail3 $mail4 $mail5)
