#!/bin/bash

imap_fetch "$Sanityuser" "1:*"      
summary "IMAP:TC_fetch_all_message_rfc822" $Result