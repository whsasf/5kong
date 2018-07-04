#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="STATUS"
exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
sleep 2
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
echo -en ""$SCRIPTTYPE"STATUS status INBOX (UIDNEXT MESSAGES UNSEEN UIDVALIDITY)\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
