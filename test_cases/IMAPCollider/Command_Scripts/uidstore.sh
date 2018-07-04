#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="UIDSTORE"

exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"INBOX select INBOX\r\n" >&3
echo -en ""$SCRIPTTYPE"UIDSTORE uid store * +flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"UIDSTORE uid store * -flags (\Deleted)\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"UIDSTORE uid store * +flags (\Deleted)\r\n" >&3
echo -en ""$SCRIPTTYPE"UIDSTORE uid store * -flags (\Deleted)\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
