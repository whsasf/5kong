#!/bin/bash
imap_lsub $Sanityuser  "test_folder2"
beforevalue=$lsub_exist
let futurevalue=beforevalue+1
imap_subscribe $Sanityuser  "test_folder2"
imap_lsub $Sanityuser  "test_folder2"
aftervalue=$lsub_exist
echo "########## beforevalue=$beforevalue" >>debug.log
echo "########## futurevalue=$futurevalue" >>debug.log
echo "########## aftervalue=$aftervalue" >>debug.log
if [ $futurevalue -eq $aftervalue ];then
	 prints "Subscribe works successfully" "IMAP_Subscribe" "2"
	 Result=0
else
   prints "Subscribe works unsuccessfully" "IMAP_Subscribe" "1"
	 Result=1
fi
summary "IMAP:TC_IMAP_Subscribe" $Result