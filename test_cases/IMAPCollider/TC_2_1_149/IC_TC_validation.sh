#!/bin/bash

echo "Verifying whether the concurrency was acheieved or not.. Please wait"
cat $INTERMAIL/log/imapserv.trace | egrep -i "C\[|S\[" |egrep -v "server" | cut -d "[" -f 2-9 | egrep -vi "login|logout" > TC_logs.txt

# Checking the number of lines from a close command to close server output
TC1_TOTAL_LINES=$(sed -e '/CLOSEINBOX close/,/CLOSEINBOX OK  CLOSE/!d' TC_logs.txt | wc -l)
echo "Total number of lines from a close command to close inbox server output ==> "$TC1_TOTAL_LINES >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
if [ $TC1_TOTAL_LINES -gt 2 ]
then
	# Checking for how many copy commands are occuring between close command and close server output.
	TC1_Head_Value=`expr $TC1_TOTAL_LINES - 1`
	echo "TC1_Head_Value ==> "$TC1_Head_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_Tail_Value=`expr $TC1_TOTAL_LINES - 2`
	echo "TC1_Tail_Value ==> "$TC1_Tail_Value >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	TC1_COPY_COUNT=$(sed -e '/CLOSEINBOX close/,/CLOSEINBOX OK  CLOSE/!d' TC_logs.txt | head -$TC1_Head_Value | tail -$TC1_Tail_Value | grep -i COPYCOPY | wc -l)
	echo "Total number of copy commands occuring between close command and close server output ==> "$TC1_COPY_COUNT >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log

	# Checking if number of Lines in which copy operations are done is more than 0 or not. If yes, print success, else fail and re-run test.
	if [ $TC1_COPY_COUNT -gt 0 ]
	then
		echo "TC_2_1_149 PASSED: Concurrency Acheieved in 'IMAP-copy' and 'IMAP-clsoe' commands."
		echo "TC_2_1_149 PASSED: Concurrency Acheieved in 'IMAP-copy' and 'IMAP-close' commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "There were $TC1_COPY_COUNT copy operation calls between a single close operation."
		echo "There were $TC1_COPY_COUNT copy operation calls between a single close operation." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo
		echo "Test Completed."
		echo "Test Completed." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "TC_2_1_149 ==> PASSED" >> $PATH_TO_SCRIPTS/Logs/IC_Summary.log
		echo "=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	else
		echo "TC_2_1_149 FAILED."
		echo "TC_2_1_149 FAILED." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		echo "Reason: Commands fired between close commands are not copy commands."
		echo "Reason: Commands fired between close commands are not copy commands." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
		$PATH_TO_SCRIPTS/TC_2_1_149/IC_TC.sh
	fi
else
	echo "TC_2_1_149 Failed"
	echo "TC_2_1_149 Failed" >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Reason: Number of lines from close command input to close server output is not proper."
	echo "Reason: Number of lines from close command input to close server output is not proper." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	echo "Running TC_2_1_149 again..."
	echo "Running TC_2_1_149 again..." >> $PATH_TO_SCRIPTS/Logs/IC_Debug.log
	$PATH_TO_SCRIPTS/TC_2_1_149/IC_TC.sh
fi

rm -rf TC_logs.txt
