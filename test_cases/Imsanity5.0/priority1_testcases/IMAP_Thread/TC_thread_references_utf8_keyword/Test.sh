#!/bin/bash
echo ${result[@]} | grep -q 1
if [ $? -ne 0 ];then
    imap_store "$Sanityuser" "4" "+" "kwtest" "INBOX"
    store_result=$Result
    if [ $store_result -eq 0 ];then            
        imap_thread "$Sanityuser" "INBOX" "REFERENCES UTF-8" "keyword kwtest"
        verify_imapthread=$(cat imapthread.tmp | grep -i "THREAD" | grep '(1 2) (3) (4)' | wc -l)
        verify_imapthread=`echo $verify_imapthread | tr -d " "`
        echo "verify_imapthread=$verify_imapthread"  >>debug.log
        if [ "$verify_imapthread" == "1" ]
        then
            prints "IMAP THREAD for $Sanityuser is successful" "TC_thread_references_utf8_keyword" "2"
            Result="0"
        else
            prints "-ERR IMAP THREAD for $Sanityuser is unsuccessful" "TC_thread_references_utf8_keyword" "1"
            Result="1"
        fi
    else
        prints "-ERR keyword stored unsuccessfully" "imap_store" "1"
        Result="1"
    fi    
else
    prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
    Result="1"
fi
summary "IMAP:TC_thread_references_utf8_keyword" $Result
