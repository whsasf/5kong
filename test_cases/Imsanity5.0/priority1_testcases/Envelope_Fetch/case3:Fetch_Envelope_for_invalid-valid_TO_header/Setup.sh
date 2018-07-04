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

immsgdelete  $Sanityuser@${default_domain}  -all 


user_mail_name=$(whoami)
MAILFROM=`imdbcontrol la | grep -i @ | grep -i $user_mail_name | cut -d ":" -f2 | cut -d "@" -f1`
MAILFROM=`echo $MAILFROM | tr -d " "`

## CASE 3 : FOR VARIOUS INVALID/VALID COMBINATION OF TO HEADER ###
prints "CASE 3 :  FOR VARIOUS INVALID/VALID COMBINATION OF TO HEADER " "Fetch_Envelope_for_invalid-valid_TO_header"  
#create messages
echo "From: $MAILFROM@${default_domain} "  > message.tmp 
echo "To: $Sanityuser@${default_domain}; anyuser " >> message.tmp
echo "Subject: Test mail" >> message.tmp
echo >> message.tmp
echo "This is a test mail ..."  >> message.tmp									 
echo "From: $MAILFROM@${default_domain} "  > message1.tmp 
echo "To: all; anyuser " >> message1.tmp
echo "Subject: Test mail" >> message1.tmp
echo >> message1.tmp
echo "This is a test mail ..."  >> message1.tmp

msg=`cat message.tmp`
msg1=`cat message1.tmp`
prints "Sending mail to $Sanityuser" "Fetch_Envelope_for_invalid-valid_TO_header" 
#sending messages
exec 3<>/dev/tcp/$MTAHost/$SMTPPort
echo -en "MAIL FROM:$MAILFROM\r\n" >&3
echo -en "RCPT TO:$Sanityuser\r\n" >&3
echo -en "DATA\r\n" >&3
echo -en "$msg\r\n" >&3
echo -en ".\r\n" >&3
echo -en "MAIL FROM:$MAILFROM\r\n" >&3
echo -en "RCPT TO:$Sanityuser\r\n" >&3
echo -en "DATA\r\n" >&3
echo -en "$msg1\r\n" >&3
echo -en ".\r\n" >&3
echo -en "QUIT\r\n" >&3
exec 3>&- 

