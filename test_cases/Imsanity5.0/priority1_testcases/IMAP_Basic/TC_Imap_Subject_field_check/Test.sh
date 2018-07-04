#!/bin/bash

sub=$(cat check.tmp | grep "Subject:" | cut -d " " -f2 )
sub=$(echo $sub | tr -d " ")
prints " subject : "$sub "imap_check" 
echo "########## Subject=$sub" >>debug.log

if [ "$sub" == "Sanity" ]
then
	    prints "Subject field in IMAP is correct" "imap_subject_field_check" 2
			Result=0
else
	    prints "Error:Subject field in IMAP is not correct" "imap_subject_field_check" "1"
			Result=1
fi
							
summary "IMAP:TC_Imap_Subject_Field_Check" $Result