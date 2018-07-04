#!/bin/bash
echo "mail1=$mail1"  >>debug.log
echo "mail2=$mail2"  >>debug.log
if [ $mail1 == 0 -a $mail2 == 0 ];then
			imap_search "$Sanityuser" "INBOX" "OR" "old larger 1000"
	    verify_imapsearch=$(cat imapsearch.tmp | grep -i "SEARCH"| grep -i "2" | wc -l)
	    verify_imapsearch=`echo $verify_imapsearch | tr -d " "`
	    echo "########## verify_imapsearch=$verify_imapsearch" >>debug.log
	    if [ "$verify_imapsearch" == "1" ]
	    then
				prints "IMAP SEARCH for $imapUser is successful" "TC_search_OR" "2"
				Result="0"
	    else
				prints "-ERR IMAP SEARCH for $imapUser is unsuccessful" "TC_search_OR" "1"
				Result="1"
	    fi
else
      prints "-ERR mail sent unsuccessful" "mail_send" "1"
      Result="1"
fi
	
summary "IMAP:TC_search_OR" $Result