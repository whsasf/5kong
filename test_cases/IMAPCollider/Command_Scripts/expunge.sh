#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="STORE"

exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX select INBOX\r\n" >&3
echo -en ""$SCRIPTTYPE"SETSTOREINBOX store 1:* +flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"UNSETSTOREINBOX store 1:* -flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"EXPUNGE expunge\r\n" >&3
sleep 2
echo -en ""$SCRIPTTYPE"SETSTOREINBOX store 1:* +flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"UNSETSTOREINBOX store 1:* -flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"EXPUNGE expunge\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"SETSTOREINBOX store 1:* +flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"UNSETSTOREINBOX store 1:* -flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"EXPUNGE expunge\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
