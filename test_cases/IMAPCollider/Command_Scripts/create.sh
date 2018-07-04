#!/bin/bash

IMAPHost=$(cat $INTERMAIL/config/config.db | grep -i imapserv_run  | grep -i on | cut -d "/" -f2)
IMAPPort=$(imconfget -m imapserv -h $IMAPHost imap4Port)

SCRIPTTYPE="CREATE"
#echo "================================="
#echo "PERFORMING IMAP CREATE OPERATIONS"
#echo "================================="
#echo "Connecting to $IMAPHost on Port $IMAPPort";
#echo "Running imap create command on INBOX. Please wait ... "

exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
echo -en "$SCRIPTTYPE login $User $User\r\n" >&3
echo -en ""$SCRIPTTYPE"CRE create ANKUR1/ANKUR2/ANKUR3/ANKUR4\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2/ANKUR3/ANKUR4\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2/ANKUR3\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"CRE create ANKUR1/ANKUR2/ANKUR3/ANKUR4\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2/ANKUR3/ANKUR4\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2/ANKUR3\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1\r\n" >&3
sleep 1
echo -en ""$SCRIPTTYPE"CRE create ANKUR1/ANKUR2/ANKUR3/ANKUR4\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2/ANKUR3/ANKUR4\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2/ANKUR3\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1/ANKUR2\r\n" >&3
echo -en ""$SCRIPTTYPE"DEL delete ANKUR1\r\n" >&3
sleep 1
echo -en "$SCRIPTTYPE logout\r\n" >&3
