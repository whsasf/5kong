#!/bin/bash
imap_fetch "$Sanityuser" "2:3" "modseq"
m1=`grep MODSEQ  imapfetch.tmp |head -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
m2=`grep MODSEQ  imapfetch.tmp |tail -1|awk -F "("  '{print $3}'|awk -F ")" '{print $1}'`
((m3=$m1*$m2))
echo "########## m1=$m1" >>debug.log
echo "########## m2=$m2" >>debug.log
echo "########## m3=$m3" >>debug.log
if [ $m3 -gt 0 -a $Result -eq 0 ];then
		prints "IMAP:TC_fetch_modseq test successfully!"  "IMAP:TC_fetch_modseq"  2
		Result=0
else
		prints "IMAP:TC_fetch_modseq test failed!"  "IMAP:TC_fetch_modseq"  1
		Result=1
fi
echo "########## Result=$Result" >>debug.log
summary "IMAP:TC_fetch_modseq" $Result
