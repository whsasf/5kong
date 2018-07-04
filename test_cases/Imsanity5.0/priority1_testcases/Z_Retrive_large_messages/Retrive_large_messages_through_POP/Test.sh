#!/bin/bash



if [ "$goon" == "1" ];then
     #clear popserv.log
     > $INTERMAIL/log/popserv.log
     #pop retrive first message
     exec 3<>/dev/tcp/$POPHost/$POPPort
		 echo -en "user $Sanityuser\r\n" >&3
		 echo -en "pass $Sanityuser\r\n" >&3
		 echo -en "retr 1\r\n" >&3
		 echo -en "quit\r\n" >&3
		 cat <&3 > popretrieve.tmp
		 #cat popretrieve.txt >> debug.log
		 check_retr=$(cat popretrieve.tmp | grep -i "+OK" | grep -i "octets" |wc -l)
		 check_retr=`echo $check_retr | tr -d " "`
		 check_content=$(cat popretrieve.tmp | grep -i "sandbox" |wc -l)
		 check_content=`echo $check_content | tr -d " "`
		 echo "########## check_retr=$check_retr"  >>debug.log
		 echo "########## check_content=$check_content" >>debug.log
		 if [ "$check_retr" -eq 1 -a  "$check_content" -gt 1 ]
		 then
				prints "POP retr command for $Sanityuser is successful" "pop_retrieve" "2"
				Result="0"
		 else
				prints "-ERR POP retr command for $Sanityuser is unsuccessful" "pop_retrieve" "1"
				Result="1"
	   fi
		 
     if [ "$Result" == "0" ];then
        cat $INTERMAIL/log/popserv.log| egrep -i "erro;|urgt;|fatl;" > pop_errors.tmp
        echo "========== the content of pop_errors.tmp ==========" >>debug.log
        cat pop_errors.tmp >> debug.log
        echo "===================================================" >>debug.log
        err_count=$(cat $INTERMAIL/log/popserv.log| egrep -i "erro;|urgt;|fatl;" | wc -l)
        echo "########## err_count=$err_count" >>debug.log
        if [ "$err_count" -gt "0" ]	
        then
                prints "Error found in popserv.log. Please check debug.log" "pop_retrieve" "1"
        else
                prints "No Error found in popserv.log." "pop_retrieve" "2"
        fi
        #error contents
        err=$(cat pop_errors.tmp | wc -l)
        err=` echo $err | tr -d " "`
        echo "##########  err=$err" >>debug.log
        if [ "$err" == "0" ]
        then
                prints " Retrieval large messages through POP is working fine " "Retrive_large_messages_through_POP" "2"
                summary "Retrieving_large_messages_through_POP" 0
        else
                prints " Retrieval large messages through POP is not working " "Retrive_large_messages_through_POP" "1"
                summary "Retrieving_large_messages_through_POP" 1 
        fi									
     else
        prints "pop_retrieve failed,please check manualy!!" "Retrive_large_messages_through_POP"  1
     fi
else
        prints "large_msg_delivery_10MB failed,please check manually!!"   "Retrive_large_messages_through_POP"  1
fi
        
