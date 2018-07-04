#!/bin/bash
imap_uid_fetch "$Sanityuser" "2:*" "modseq"
m1=`grep MODSEQ  imapuidfetch.tmp |head -1|awk -F "("  '{print $3}'|awk -F ")" '{print $2}'|awk '{print $2}'`
m2=`grep MODSEQ  imapuidfetch.tmp |tail -1|awk -F "("  '{print $3}'|awk -F ")" '{print $2}'|awk '{print $2}'`
echo "########## m1=$m1"  >>debug.log
echo "########## m2=$m2"  >>debug.log

if [ $m1 -gt 1000 -a  $m2 -gt 1000  -a $Result -eq 0 ];then
		prints "IMAP:TC_uid_fetch_modseq test successfully!"  "IMAP:TC_uid_fetch_modseq"  2
		Result=0
else
		prints "IMAP:TC_uid_fetch_modseq test failed!"  "IMAP:TC_uid_fetch_modseq"  1
		Result=1
fi
echo "########## Result=$Result"  >>debug.log
summary "IMAP:TC_uid_fetch_modseq" $Result
