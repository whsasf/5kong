#!/bin/bash
imap_fetch "$Sanityuser" "1" "body[text]"   
summary "IMAP:TC_fetch_single_message_body_text" $Result