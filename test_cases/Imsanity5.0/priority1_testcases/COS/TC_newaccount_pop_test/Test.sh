#!/bin/bash
#send 2 mails
mail_send "$Sanityuser" "small" "2"	
#fetch message
pop_retrieve "$Sanityuser" "1"
#cat popretrieve.txt
summary "COS:TC_newaccount_pop_test" $Result
