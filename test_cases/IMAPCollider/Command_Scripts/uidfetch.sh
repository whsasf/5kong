#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="UIDFETCH"

exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"SELECTINBOX select INBOX\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX uid fetch 1:* rfc822\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX uid fetch 1:* rfc822\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX uid fetch 1:* rfc822\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX uid fetch 1:* rfc822\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX uid fetch 1:* rfc822\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX uid fetch 1:* rfc822\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
