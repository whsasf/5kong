#!/bin/bash

export PATH_TO_SCRIPTS=$(pwd)
export id=`echo $RANDOM`
export User=concuser$id

$PATH_TO_SCRIPTS/IC_Setup.sh

# CHecking for test suite file
file_count=$(ls -lrt $PATH_TO_SCRIPTS | grep -i temp | wc -l)
if [ $file_count -gt 0 ]
then
        #echo "Found 1 Test suite file1. Using it for Test Run."
        echo
else
        echo "ERROR: No Test suite file was generated/found. Please check"
        exit
fi

#Running Test Cases
TEMPLOGFILE=$PATH_TO_SCRIPTS/temp.txt
while read TEST_CASE
do
	echo "##############################"
	echo "   STARTING TEST $TEST_CASE   "
	echo "##############################"
	$PATH_TO_SCRIPTS/$TEST_CASE/IC_TC.sh
	sleep 2
done <$TEMPLOGFILE

$PATH_TO_SCRIPTS/IC_Cleanup.sh
cat $PATH_TO_SCRIPTS/Logs/IC_Summary.log
