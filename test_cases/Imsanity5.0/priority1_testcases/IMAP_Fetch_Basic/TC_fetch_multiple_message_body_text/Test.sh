#!/bin/bash

imap_fetch "$Sanityuser" "1,2,3" "body[text]"    
summary "IMAP:TC_fetch_multiple_message_body_text" $Result