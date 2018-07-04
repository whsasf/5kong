#!/bin/bash

echo "Verifying whether the concurrency was acheieved or not.. Please wait"
cat $INTERMAIL/log/imapserv.trace | egrep -i "C\[|S\[" |egrep -v "server" | cut -d "[" -f 2-9 | egrep -vi "login|logout" > TC_logs.txt

# Checking the number of lines from a select command to select server output
TC1_TOTAL_LINES=$(sed -e '/SELECTINBOX select/,/SELECTINBOX OK/!d' TC_logs.txt | wc -l)
echo "Total number of lines from a select command to select inbox server output ==> "$TC1_TOTAL_LINES >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
if [ $TC1_TOTAL_LINES -gt 2 ]
then
	# Checking for how many uidsearch commands are occuring between select command and select server output.
	TC1_Head_Value=`expr $TC1_TOTAL_LINES - 1`
	echo "TC1_Head_Value ==> "$TC1_Head_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_Tail_Value=`expr $TC1_TOTAL_LINES - 2`
	echo "TC1_Tail_Value ==> "$TC1_Tail_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_UIDSEARCH_COUNT=$(sed -e '/SELECTINBOX select/,/SELECTINBOX OK/!d' TC_logs.txt | head -$TC1_Head_Value | tail -$TC1_Tail_Value | grep -i UIDSEARCHUIDSERINBOX | wc -l)
	echo "Total number of uidsearch commands occuring between select command and select server output ==> "$TC1_UIDSEARCH_COUNT >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log

	# Checking if number of Lines in which uidsearch operations are done is more than 0 or not. If yes, print success, else fail and re-run test.
	if [ $TC1_UIDSEARCH_COUNT -gt 0 ]
	then
		echo "TC_2_1_35 PASSED: Concurrency Acheieved in 'IMAP-uidsearch' and 'IMAP-select' commands."
		echo "TC_2_1_35 PASSED: Concurrency Acheieved in 'IMAP-uidsearch' and 'IMAP-select' commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "There were $TC1_UIDSEARCH_COUNT uidsearch operation calls between a single select operation."
		echo "There were $TC1_UIDSEARCH_COUNT uidsearch operation calls between a single select operation." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo
		echo "Test Completed."
		echo "Test Completed." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "TC_2_1_35 ==> PASSED" >> $PATH_TO_SCRIPTS/Logs/IC_Summary.log
		echo "=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	else
		echo "TC_2_1_35 FAILED."
		echo "TC_2_1_35 FAILED." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "Reason: Commands fired between select commands are not uidsearch commands."
		echo "Reason: Commands fired between select commands are not uidsearch commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		$PATH_TO_SCRIPTS/TC_2_1_35/IC_TC.sh
	fi
else
	echo "TC_2_1_35 Failed"
	echo "TC_2_1_35 Failed" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Reason: Number of lines from select command input to select server output is not proper."
	echo "Reason: Number of lines from select command input to select server output is not proper." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Running TC_2_1_35 again..."
	echo "Running TC_2_1_35 again..." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	$PATH_TO_SCRIPTS/TC_2_1_35/IC_TC.sh
fi

rm -rf TC_logs.txt
