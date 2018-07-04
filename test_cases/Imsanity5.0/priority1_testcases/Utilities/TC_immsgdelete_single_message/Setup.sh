#!/bin/bash
> debug.log
> summary.log
#Result=1_by_fefault
Result=1
start_time_tc

#create test account
Sanityuser=test$(echo $RANDOM)
account_create_fn  $Sanityuser

imboxstats $Sanityuser@${default_domain} &>accountexist.tmp
ec=$(grep -i "Unable to get mailbox" accountexist.tmp |wc -l)
if [ "$ec" -eq 1 ];then
	account_create_fn $Sanityuser
fi
immsgdelete $Sanityuser@${default_domain} -all 
user_mail_name=$(whoami)
MAILFROM=`imdbcontrol la | grep -i @ | grep -i $user_mail_name | cut -d ":" -f2 | cut -d "@" -f1`
MAILFROM=`echo $MAILFROM | tr -d " "`
        
#deliever a message and get it's msgid
exec 3<>/dev/tcp/$MTAHost/$SMTPPort
echo -en "MAIL FROM:$MAILFROM\r\n" >&3
echo -en "RCPT TO:$Sanityuser\r\n" >&3
echo -en "DATA\r\n" >&3
echo -en "Subject: Test immsgdelete single message\r\n\r\n" >&3
echo -en "$DATA\r\n" >&3
echo -en ".\r\n" >&3
echo -en "QUIT\r\n" >&3
cat <&3 >> mail.tmp
echo "========== the content of mail.tmp ==========" >>debug.log
cat mail.tmp >>debug.log
echo "=============================================" >>debug.log

immsgdump $Sanityuser@${default_domain} 0 > msgdump.tmp
echo "========== the content of msgdump.tmp ==========" >>debug.log
cat msgdump.tmp  >>debug.log
echo "================================================" >>debug.log





							   
