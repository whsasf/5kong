#!/bin/bash

echo "-----------------------------------------------"
echo "Which category testcases you want to test for?"
echo "        For P1 only enter 1 - Currently only this is supported as all TCs are marked P1."
echo "        For P1 and P2 both enter 12"
echo "        For complete suite enter 123"
echo "NOTE: By default, if no choice is entered, all test cases will be executed."
echo "-----------------------------------------------"
echo "Enter any one choice: "
#read choice
choice=1
if [ $choice -eq 1 ]
then
	Prty="Priority1"
elif [ $choice -eq 12 ]
then
	#Prty="Priority1|Priority2"
	Prty="Priority1"
elif [ $choice -eq 123 ]
then
	#Prty="Priority"
	Prty="Priority1"
else
	echo "No Choice entered. By default, all tests are considered."
	#Prty="Priority"
	Prty="Priority1"
fi

echo "#############################"
echo "       Starting SETUP        "
echo "#############################"

echo "Creating the user for the concurrency tests."
MailboxID=$(imboxstats concuser$id@openwave.com | head -1 | awk -F" " '{print $3}' | cut -d ":" -f2)
Clusterboxstats=$(imboxstats concuser$id@openwave.com | head -1 | awk -F" " '{print $5}' | cut -d ":" -f1)

isUserThere=$(imdbcontrol la | grep -i @ | awk -F" " '{print $2}' | cut -d "@" -f1 | grep -i "^concuser$id$")
if [ "$isUserThere" == "concuser$id" ]
then
        echo "User already exists."
        echo "Checking for messages in it."
        existingMsgs=$(imboxstats concuser$id@openwave.com | egrep -i "Messages Stored" | awk -F" " '{print $NF}')
        while [ $existingMsgs -gt 0 ]
        do
                echo "There are still messages in the mailbox."
                echo "Resetting the mailbox."
                account-delete concuser$id@openwave.com
                account-create concuser$id@openwave.com concuser$id default -mboxid $id
                existingMsgs=$(imboxstats concuser$id@openwave.com | egrep -i "Messages Stored" | awk -F" " '{print $4}')
        done
        echo "User is ready for concurrency testing."
else
        echo "User does not exists. Creating one."
        cluster=$(imconfget -m mss clusterName)
        #imdbcontrol ca concuser$id $cluster $id concuser$id concuser$id clear
        account-create concuser$id@openwave.com concuser$id default -mboxid $id
        isUserThere=$(imdbcontrol la | grep -i @ | awk -F" " '{print $2}' | cut -d "@" -f1 | grep -i "^concuser$id$")
        if [ $isUserThere == "concuser$id" ]
        then
                echo "User is created Successfully."
                echo "Checking for messages in it."
              #  imboxcreate $cluster $id
                existingMsgs=$(imboxstats concuser$id@openwave.com | egrep -i "Messages Stored" | awk -F" " '{print $4}')
        echo "User is ready for concurrency testing."
        fi
fi

echo "Setting traceOutput Config key to 'imap=2'"
imconfcontrol -install -key "/*/common/traceOutputLevel"="imap=2" > config_changes.txt
echo "Config changes done Successfully."
#echo
echo "Resetting IMAP TRACE Logs"
>$INTERMAIL/log/imapserv.trace
echo "Imap Traces resetted Successfully."
#echo
echo "Creating test suite file.."
cat IC_TCs_Priority_List.txt | grep -i $Prty | cut -d " " -f1 > temp.txt
echo "Setup Completed."
echo "============================="
echo

# Initiating IC_Debug.log and IC_Summary.log files
echo "##############################################" > $PATH_TO_SCRIPTS/Logs/IC_Debug.log
echo "     Detailed Logs to be used for Debugging   " >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
echo "##############################################" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
echo >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log

echo "##########################################################" > $PATH_TO_SCRIPTS/Logs/IC_Summary.log
echo "     High Level Summary of all the Test Cases Executed    " >> $PATH_TO_SCRIPTS/Logs/IC_Summary.log
echo "##########################################################" >> $PATH_TO_SCRIPTS/Logs/IC_Summary.log
echo >> $PATH_TO_SCRIPTS/Logs/IC_Summary.log
