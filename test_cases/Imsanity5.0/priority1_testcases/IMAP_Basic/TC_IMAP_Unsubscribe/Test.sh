#!/bin/bash
imap_lsub $Sanityuser  "test_folder3"
beforevalue=$lsub_exist
let futurevalue=beforevalue-1
imap_unsubscribe $Sanityuser  "test_folder3"
imap_lsub $Sanityuser  "test_folder3"
aftervalue=$lsub_exist
echo "########## beforevalue=$beforevalue" >>debug.log
echo "########## futurevalue=$futurevalue" >>debug.log
echo "########## aftervalue=$aftervalue" >>debug.log

if [ $futurevalue -eq $aftervalue ];then
	 prints "Unsubscribe works successfully" "IMAP_Unsubscribe" "2"
	 Result=0
else
   prints "Unsubscribe works unsuccessfully" "IMAP_Unsubscribe" "1"
	 Result=1
fi
summary "IMAP:TC_IMAP_Unsubscribe" $Result