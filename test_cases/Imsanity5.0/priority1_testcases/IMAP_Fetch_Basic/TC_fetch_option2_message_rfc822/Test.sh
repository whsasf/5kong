#!/bin/bash
imap_fetch "$Sanityuser" "1:2,3"      
summary "IMAP:TC_fetch_option2_message_rfc822" $Result