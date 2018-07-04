#!/bin/bash
#send 2 mails
mail_send "$Sanityuser" "small" "2"
#fetch message
imap_fetch "$Sanityuser" "1" "rfc822"
summary "COS:TC_newaccount_imap_test" $Result
