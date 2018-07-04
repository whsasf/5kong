#!/bin/bash

to=$(cat check.tmp | grep -i "for " | cut -d "<" -f2| cut -d ">" -f1|head -1)
to=` echo $to | tr -d " "`
prints "to: "$to "imap_check"
echo "########## To=$to" >>debug.log

if [ "$to" == "$user1@${default_domain}" ]
then
		    prints "TO field in IMAP is correct" "imap_to_field_check" 2
				Result=0
else
		    prints "Error:TO field in IMAP is not correct" "imap_to_field_check" "1"
				Result=1
fi							
							
summary "IMAP:TC_Imap_TO_Field_Check" $Result