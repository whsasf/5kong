#!/bin/bash
echo ${result[@]} | grep -q 1 
if [ $? -ne 0 ];then
    imap_thread "$Sanityuser" "INBOX" "REFERENCES UTF-8" "all"
    verify_imapthread=$(cat imapthread.tmp | grep -i "THREAD" | grep '(1 3) (2 4) (5)' | wc -l)
    verify_imapthread=`echo $verify_imapthread | tr -d " "`
    echo "verify_imapthread=$verify_imapthread" >>debug.log
    if [ "$verify_imapthread" == "1" ]
    then
        prints "IMAP THREAD for $Sanityuser is successful" "TC_thread_references_utf8_all" "2"
        Result="0"
    else
        prints "-ERR IMAP THREAD for $Sanityuser is unsuccessful" "TC_thread_references_utf8_all" "1"
        Result="1"
    fi
else
    prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
    Result="1"
fi
summary "IMAP:TC_thread_references_utf8_all" $Result
