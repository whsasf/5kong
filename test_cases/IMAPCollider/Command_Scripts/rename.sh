#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="RENAME"

exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"CRE create CONC\r\n" >&3
echo -en ""$SCRIPTTYPE"RENAME rename CONC CURRENCY\r\n" >&3
echo -en ""$SCRIPTTYPE"RENAME rename CURRENCY CONC\r\n" >&3
echo -en ""$SCRIPTTYPE"RENAME rename CONC CURRENCY\r\n" >&3
echo -en ""$SCRIPTTYPE"RENAME rename CURRENCY CONC\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"RENAME rename CONC CURRENCY\r\n" >&3
echo -en ""$SCRIPTTYPE"RENAME rename CURRENCY CONC\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete CONC\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
