#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="SELECT"
#echo "================================="
#echo "PERFORMING IMAP SELECT OPERATIONS"
#echo "================================="
#echo "Connecting to $IMAPHost on Port $IMAPPort";
#echo "Running imap select command on INBOX, Trash and SentMail. Please wait ... "
exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX select INBOX\r\n" >&3
echo -en ""$SCRIPTTYPE"SENTMAIL select SentMail\r\n" >&3
echo -en ""$SCRIPTTYPE"TRASH select Trash\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"INBOX select INBOX\r\n" >&3
echo -en ""$SCRIPTTYPE"SENTMAIL select SentMail\r\n" >&3
echo -en ""$SCRIPTTYPE"TRASH select Trash\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
