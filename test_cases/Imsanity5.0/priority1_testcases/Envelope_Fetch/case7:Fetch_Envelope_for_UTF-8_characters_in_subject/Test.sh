#!/bin/bash

imboxstats $Sanityuser@${default_domain} > boxstats.tmp
echo "========== the content of boxstats.tmp ==========" >>debug.log
cat boxstats.tmp >>debug.log
echo "=================================================" >>debug.log
msgs_user=$(grep "Total Messages Stored"  boxstats.tmp | cut -d ":" -f2)
msgs_user=`echo $msgs_user | tr -d " "`
echo "########## msgs_user=$msgs_user" >>debug.log
if [ $msgs_user -gt 0 ]
then
      prints "PERFORMING IMAP FETCH ENVELOPE" "Fetch_Envelope_for_UTF-8_characters_in_subject" 
      echo > temporary.tmp
      exec 3<>/dev/tcp/$IMAPHost/$IMAPPort
      echo -en "a login $Sanityuser $Sanityuser\r\n" >&3
      echo -en "a select INBOX\r\n" >&3
      echo -en "a fetch 1:* envelope\r\n" >&3
      echo -en "a logout\r\n" >&3
      cat <&3 >temporary.tmp
      echo "========== the content of temporary.tmp ==========" >>debug.log
      cat temporary.tmp >> debug.log
      echo "==================================================" >>debug.log
 
      invalid_field=$(cat temporary.tmp | grep -i "()" | wc -l)
      invalid_field=`echo $invalid_field | tr -d " " `
      echo "########## invalid_field=$invalid_field" >>debug.log
      if [ $invalid_field -gt 0 ]
      then
          prints "Invalid header field found in fetch envelope " "Fetch_Envelope_for_UTF-8_characters_in_subject" "1"
		      prints "Scenario 7:Fetch_Envelope_for_UTF-8_characters_in_subject is not working fine "	"Fetch_Envelope_for_UTF-8_characters_in_subject" "1"
          summary "Fetch_Envelope_for_UTF-8_characters_in_subject" 1 									  
      else
          prints "Invalid header field not found in fetch envelope " "Fetch_Envelope_for_UTF-8_characters_in_subject" "2"
	 	      prints "Scenario 7:Fetch_Envelope_for_UTF-8_characters_in_subject is working fine " "Fetch_Envelope_for_UTF-8_characters_in_subject" "2"
          summary "Fetch_Envelope_for_UTF-8_characters_in_subject" 0										  
     fi										 
else
        prints "Mails not delivered " "Fetch_Envelope_for_UTF-8_characters_in_subject" "1"
		    summary "Fetch_Envelope_for_UTF-8_characters_in_subject" 1
fi