#!/bin/bash
echo ${result[@]} | grep -q 1
if [ $? -ne 0 ];then
      imap_copy "$Sanityuser" "5" "SentMail" "INBOX"
      copy_result=$Result
      echo "copy_result=$copy_result">>debug.log
			imap_store "$Sanityuser" "5" "+" "\Deleted" "INBOX"
      store_result=$Result
      echo "store_result=$store_result"  >>debug.log
			imap_expunge "$Sanityuser"
      expunge_result=$Result
      echo "expunge_result=$expunge_result"  >>debug.log
      result1=($copy_result $store_result $expunge_result)
      echo ${result1[@]} | grep -q 1
      if [ $? -ne 0 ];then            
          imap_thread "$Sanityuser" "SentMail" "REFERENCES UTF-8" "all"
          verify_imapthread=$(cat imapthread.tmp | grep -i "THREAD" | grep '(1 2 4) (3 5)' | wc -l)
          verify_imapthread=`echo $verify_imapthread | tr -d " "`
          echo "verify_imapthread=$verify_imapthread"  >>debug.log
          if [ "$verify_imapthread" == "1" ]
          then
              prints "IMAP THREAD for $Sanityuser is successful" "TC_thread_references_utf8_copy" "2"
              Result="0"
          else
              prints "-ERR IMAP THREAD for $Sanityuser is unsuccessful" "TC_thread_references_utf8_copy" "1"
              Result="1"
          fi
      else
          prints "-ERR keyword stored unsuccessfully" "imap_copy" "1"
          Result="1"
      fi    
else
      prints "-ERR mail delivered unsuccessfully" "mail_send_thread" "1"
      Result="1"
fi
summary "IMAP:TC_thread_references_utf8_copy" $Result