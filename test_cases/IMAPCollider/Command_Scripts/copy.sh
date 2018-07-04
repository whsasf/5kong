#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="COPY"

exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"SELECT select INBOX\r\n" >&3
echo -en ""$SCRIPTTYPE"APPEND append INBOX {1500}\r\n" >&3
echo -en "1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234567890abcd1234567890abcdefghijklmnopqrstuvwxyz1234\n" >&3
echo -en ""$SCRIPTTYPE"CREATE create COPYFOLDER\r\n" >&3
echo -en ""$SCRIPTTYPE"COPY copy 1:1 COPYFOLDER\r\n" >&3
echo -en ""$SCRIPTTYPE"DELETE delete COPYFOLDER\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
