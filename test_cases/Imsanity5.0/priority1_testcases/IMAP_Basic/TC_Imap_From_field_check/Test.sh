#!/bin/bash

from=$(cat check.tmp | grep "From:" | cut -d "<" -f2| cut -d ">" -f1 )
from=` echo $from | tr -d " "`
echo "########## From=$from" >>debug.log
prints "from : "$from "imap_from_field_check" 

if [ "$from" == "$MAILFROM@${default_domain}" ]
then
	    prints "From field in IMAP is correct" "imap_from_field_check" 2
			Result=0
else
	    prints "Error:From field in IMAP is not correct" "imap_from_field_check" "1"
			Result=1 
fi

summary "IMAP:TC_Imap_From_Field_Check" $Result