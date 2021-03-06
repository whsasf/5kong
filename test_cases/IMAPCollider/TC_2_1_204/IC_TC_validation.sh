#!/bin/bash

echo "Verifying whether the concurrency was acheieved or not.. Please wait"
cat $INTERMAIL/log/imapserv.trace | egrep -i "C\[|S\[" |egrep -v "server" | cut -d "[" -f 2-9 | egrep -vi "login|logout" > TC_logs.txt

# Checking the number of lines from a status command to status server output
TC1_TOTAL_LINES=$(sed -e '/STATUSSTATUS status INBOX/,/STATUSSTATUS OK  STATUS/!d' TC_logs.txt | wc -l)
echo "Total number of lines from a status command to status inbox server output ==> "$TC1_TOTAL_LINES >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
if [ $TC1_TOTAL_LINES -gt 2 ]
then
	# Checking for how many uidfetch commands are occuring between status command and status server output.
	TC1_Head_Value=`expr $TC1_TOTAL_LINES - 1`
	echo "TC1_Head_Value ==> "$TC1_Head_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_Tail_Value=`expr $TC1_TOTAL_LINES - 2`
	echo "TC1_Tail_Value ==> "$TC1_Tail_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_UIDFETCH_COUNT=$(sed -e '/STATUSSTATUS status INBOX/,/STATUSSTATUS OK  STATUS/!d' TC_logs.txt | head -$TC1_Head_Value | tail -$TC1_Tail_Value | grep -i UIDFETCHINBOX | wc -l)
	echo "Total number of uidfetch commands occuring between status command and status server output ==> "$TC1_UIDFETCH_COUNT >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log

	# Checking if number of Lines in which uidfetch operations are done is more than 0 or not. If yes, print success, else fail and re-run test.
	if [ $TC1_UIDFETCH_COUNT -gt 0 ]
	then
		echo "TC_2_1_204 PASSED: Concurrency Acheieved in 'IMAP-uidfetch' and 'IMAP-status' commands."
		echo "TC_2_1_204 PASSED: Concurrency Acheieved in 'IMAP-uidfetch' and 'IMAP-status' commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "There were $TC1_UIDFETCH_COUNT uidfetch operation calls between a single status operation."
		echo "There were $TC1_UIDFETCH_COUNT uidfetch operation calls between a single status operation." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo
		echo "Test Completed."
		echo "Test Completed." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "TC_2_1_204 ==> PASSED" >> $PATH_TO_SCRIPTS/Logs/IC_Summary.log
		echo "=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	else
		echo "TC_2_1_204 FAILED."
		echo "TC_2_1_204 FAILED." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "Reason: Commands fired between status commands are not uidfetch commands."
		echo "Reason: Commands fired between status commands are not uidfetch commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		$PATH_TO_SCRIPTS/TC_2_1_204/IC_TC.sh
	fi
else
	echo "TC_2_1_204 Failed"
	echo "TC_2_1_204 Failed" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Reason: Number of lines from status command input to status server output is not proper."
	echo "Reason: Number of lines from status command input to status server output is not proper." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Running TC_2_1_204 again..."
	echo "Running TC_2_1_204 again..." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	$PATH_TO_SCRIPTS/TC_2_1_204/IC_TC.sh
fi

rm -rf TC_logs.txt
