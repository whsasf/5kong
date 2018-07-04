#!/bin/bash



if [ "$goon" == "1" ];then
     #clear imapserv.log
     > $INTERMAIL/log/imapserv.log
     #imap retrive first message
     exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
		 echo -en "a login $Sanityuser $Sanityuser\r\n" >&3
		 echo -en "a select INBOX\r\n" >&3
		 echo -en "a fetch 1 rfc822\r\n" >&3
		 echo -en "a logout\r\n" >&3
		 cat <&3 > imapfetch.tmp
		 #cat imapfetch.txt >> debug.log 
			
		 check_imapfetch=$(cat imapfetch.tmp | grep -i "OK FETCH completed" | wc -l)
		 check_imapfetch=`echo $check_imapfetch | tr -d " "`
		 check_target=$(cat imapfetch.tmp | grep -i "sandbox" |wc -l)
		 check_target=`echo $check_target | tr -d " "`
		 echo "########## check_imapfetch=$check_imapfetch" >>debug.log
		 echo "########## check_target=$check_target" >>debug.log
		 if [ "$check_imapfetch" -eq  1 -a "$check_target" -gt 1 ]
		 then
			  	prints "IMAP Fetch command for rfc822 for $Sanityuser is successful" "imap_fetch" "2"
				  Result="0"
		 else
			  	prints "-ERR IMAP Fetch command for rfc822 for $Sanityuser is unsuccessful" "imap_fetch" "1"
				  Result="1"
		 fi
		 #check log		 
     if [ "$Result" == "0" ];then
        cat $INTERMAIL/log/imapserv.log| egrep -i "erro;|urgt;|fatl;" > imap_errors.tmp
        err_count=$(cat $INTERMAIL/log/imapserv.log| egrep -i "erro;|urgt;|fatl;" | wc -l)
        echo "########## err_count=$err_count" >>debug.log
        if [ "$err_count" -gt "0" ]	
        then
                prints "Error found in imapserv.log. Please check debug.log" "imap_fetch" "1"
        else
                prints "No Error found in imapserv.log." "imap_fetch" "2"
        fi
        echo "========== the content of imap_errors.tmp ==========" >>debug.log
        cat imap_errors.tmp >> debug.log
        echo "====================================================" >>debug.log
        
        #errors 	
        err=$(cat imap_errors.tmp | wc -l)
        err=` echo $err | tr -d " "`
        echo "########## err=$err" >>debug.log
        if [ "$err" == "0" ]
        then
                prints " Retrieval large messages through IMAP is working fine " "Retrive_large_messages_through_IMAP" "2"
                summary "Retrieving_large_messages_through_IMAP" 0
        else
                prints " Retrieval large messages through IMAP is not working " "Retrive_large_messages_through_IMAP" "1"
                summary "Retrieving_large_messages_through_IMAP" 1 
        fi		
     else
        prints "imap_fetch failed,please check manualy!!" "Retrive_large_messages_through_IMAP"  1
     fi
else
        prints "large_msg_delivery_10MB failed,please check manually!!"   "Retrive_large_messages_through_IMAP"  1
fi
        
