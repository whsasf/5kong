#!/bin/bash

echo "Verifying whether the concurrency was acheieved or not.. Please wait"
cat $INTERMAIL/log/imapserv.trace | egrep -i "C\[|S\[" |egrep -v "server" | cut -d "[" -f 2-9 | egrep -vi "login|logout" > TC_logs.txt

# Checking the number of lines from a list command to list server output
TC1_TOTAL_LINES=$(sed -e '/LISTINBOX list/,/LISTINBOX OK  LIST/!d' TC_logs.txt | wc -l)
echo "Total number of lines from a list command to list inbox server output ==> "$TC1_TOTAL_LINES >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
if [ $TC1_TOTAL_LINES -gt 2 ]
then
	# Checking for how many search commands are occuring between list command and list server output.
	TC1_Head_Value=`expr $TC1_TOTAL_LINES - 1`
	echo "TC1_Head_Value ==> "$TC1_Head_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_Tail_Value=`expr $TC1_TOTAL_LINES - 2`
	echo "TC1_Tail_Value ==> "$TC1_Tail_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_SEARCH_COUNT=$(sed -e '/LISTINBOX list/,/LISTINBOX OK  LIST/!d' TC_logs.txt | head -$TC1_Head_Value | tail -$TC1_Tail_Value | grep -i SEARCHSERINBOX | wc -l)
	echo "Total number of search commands occuring between list command and list server output ==> "$TC1_SEARCH_COUNT >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log

	# Checking if number of Lines in which search operations are done is more than 0 or not. If yes, print success, else fail and re-run test.
	if [ $TC1_SEARCH_COUNT -gt 0 ]
	then
		echo "TC_2_1_124 PASSED: Concurrency Acheieved in 'IMAP-search' and 'IMAP-list' commands."
		echo "TC_2_1_124 PASSED: Concurrency Acheieved in 'IMAP-search' and 'IMAP-list' commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "There were $TC1_SEARCH_COUNT search operation calls between a single list operation."
		echo "There were $TC1_SEARCH_COUNT search operation calls between a single list operation." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo
		echo "Test Completed."
		echo "Test Completed." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "TC_2_1_124 ==> PASSED" >> $PATH_TO_SCRIPTS/Logs/IC_Summary.log
		echo "=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	else
		echo "TC_2_1_124 FAILED."
		echo "TC_2_1_124 FAILED." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "Reason: Commands fired between list commands are not search commands."
		echo "Reason: Commands fired between list commands are not search commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		$PATH_TO_SCRIPTS/TC_2_1_124/IC_TC.sh
	fi
else
	echo "TC_2_1_124 Failed"
	echo "TC_2_1_124 Failed" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Reason: Number of lines from list command input to list server output is not proper."
	echo "Reason: Number of lines from list command input to list server output is not proper." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Running TC_2_1_124 again..."
	echo "Running TC_2_1_124 again..." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	$PATH_TO_SCRIPTS/TC_2_1_124/IC_TC.sh
fi

rm -rf TC_logs.txt
