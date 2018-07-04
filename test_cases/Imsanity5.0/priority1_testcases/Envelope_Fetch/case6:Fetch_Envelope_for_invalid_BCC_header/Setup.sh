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

## CASE 6 : FOR INVALID BCC HEADER ###
prints "CASE 6 :  FOR INVALID BCC HEADER " "Fetch_Envelope_for_invalid_BCC_header" 
echo "From: $MAILFROM@${default_domain} "  > message.tmp 
echo "To: $Sanityuser@${default_domain}; anyuser " >> message.tmp
echo "BCC: unknown" >> message.tmp
echo "Subject: Test mail" >> message.tmp
echo >> message.tmp
echo "This is a test mail ..."  >> message.tmp

msg=`cat message.tmp`
prints "Sending mail to $Sanityuser" "Fetch_Envelope_for_invalid_BCC_header" 
exec 3<>/dev/tcp/$MTAHost/$SMTPPort
echo -en "MAIL FROM:$MAILFROM\r\n" >&3
echo -en "RCPT TO:$Sanityuser\r\n" >&3
echo -en "DATA\r\n" >&3
echo -en "$msg\r\n" >&3
echo -en ".\r\n" >&3
echo -en "QUIT\r\n" >&3
exec 3>&- 